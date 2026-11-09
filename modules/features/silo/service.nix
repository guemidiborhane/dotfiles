{ self, lib, ... }:
{
  # Validation for silo, colocated with the module (see modules/dex/dex.nix
  # `flake.dex.rules`). The module is imported when features.silo.enable is set
  # (entrypoint featureGuard); once imported it is simply active.
  flake.dex.rules = [
    (
      { features, secrets, ... }:
      let
        silo = features.silo or { };
      in
      lib.optional (
        (silo.enable or false) && (secrets.silo.secretKey or "") == ""
      ) "secrets.silo.secretKey must be set when silo is enabled (`openssl rand -base64 48`)."
    )
    # Silo exposes a Jellyfin-compatible listener on the same default port
    # (8096) as the standalone jellyfin service; running both conflicts.
    (
      { features, ... }:
      lib.optional (
        (features.silo.enable or false) && (features.jellyfin or false)
      ) "features.silo and features.jellyfin are mutually exclusive (both bind the Jellyfin port)."
    )
  ];

  # Silo — self-hosted media server for films, series, audiobooks, ebooks,
  # podcasts, and manga. https://github.com/Silo-Server/silo-server
  #
  # Silo is pre-release: APIs, configuration, and database migrations may change
  # between versions. Back up your deployment — and especially SECRET_KEY —
  # before updating.
  #
  # SECRET_KEY encrypts credentials at rest. Losing it makes that data
  # unrecoverable, so store `secrets.silo.secretKey` OUTSIDE the database
  # backup.
  #
  # This module builds the native server (./silo.nix) and provisions its
  # datastores: PostgreSQL with the pgvector extension and Redis.
  #
  # Configurable via features.silo: enable, port, jellyfinPort, uid, gid.
  # Everything else is fixed below; the SECRET_KEY comes from
  # secrets.silo.secretKey.
  flake.dex.apps.silo = {
    module = self.modules.nixos.silo-service;
    external = true;
    # Pass the host GPU into the container for hardware transcoding (NVENC on
    # koto). The generator binds /dev/dri, /run/opengl-driver and the device
    # nodes; the -service body adds the NVIDIA userspace (nvidia-smi) silo's
    # hw_accel=auto needs to verify the backend.
    gpu = true;
    ports = [
      { host = 8090; }
      { host = 8096; }
    ];
    # Silo's app data and its PostgreSQL cluster both survive container
    # rebuilds. postgres keeps its default /var/lib/postgresql dataDir inside the
    # container (a custom dataDir nested under /var/lib/silo fights the service's
    # ProtectSystem=strict sandbox); on the host its cluster lives at
    # /var/lib/silo-postgresql so it's clearly silo's, not a host postgres.
    state = {
      "/var/lib/silo" = "/var/lib/silo";
      "/var/lib/silo-postgresql" = "/var/lib/postgresql";
    };
    # Media lives on the host disks declared in hardware.mounts. Mount each at
    # the same path inside the container, so silo serves it. Read-write because
    # silo reads and writes its .nfo metadata sidecars next to the media.
    mountsReadOnly = false;
    mounts =
      ctx: lib.mapAttrs' (_uuid: path: lib.nameValuePair path path) (ctx.hardware.mounts or { });
  };

  flake.modules.nixos.silo-service =
    {
      pkgs,
      lib,
      secrets,
      features,
      hardware,
      ...
    }:
    let
      cfg = features.silo;

      inherit (pkgs) silo;

      port = cfg.port or 8090;
      jellyfinPort = cfg.jellyfinPort or 8096;
      audiobookshelfPort = 13378;

      # silo must run as the owner of the media/.nfo files on disk (nspawn maps
      # uids 1:1). Defaults to the uid/gid silo used on bare metal; override per
      # host via features.silo.{uid,gid} if the media is owned differently.
      uid = cfg.uid or 990;
      gid = cfg.gid or 984;

      dataDir = "/var/lib/silo";

      dbName = "silo";

      redisPort = 6390;

      # Local peer auth over the Unix socket — no password in DATABASE_URL. The
      # user is set explicitly so the pgx driver does not fall back to the
      # process UID's login name (which peer auth would then reject).
      databaseUrl = "postgres://silo@/${dbName}?host=/run/postgresql&sslmode=disable";
      redisUrl = "redis://127.0.0.1:${toString redisPort}/0";
    in
    {
      # silo's hw_accel=auto probes for nvidia-smi to verify the NVIDIA backend
      # (the driver libs come from the host's /run/opengl-driver, bound in by the
      # generator). Only add it on NVIDIA hosts; elsewhere DRI/VAAPI is enough.
      environment.systemPackages = [
        silo
      ]
      ++ lib.optional hardware.hasNvidia pkgs.linuxPackages.nvidia_x11.bin;

      # Pin silo to the uid/gid that owns the media/.nfo files on disk (set via
      # features.silo.{uid,gid}); nspawn maps uids 1:1 so the on-disk owner must
      # match. Without this silo gets a dynamic uid and can't read its 600-mode
      # sidecar files.
      users.users.silo = {
        isSystemUser = true;
        inherit uid;
        group = "silo";
        home = dataDir;
      };
      users.groups.silo.gid = gid;

      services.postgresql = {
        enable = true;
        extensions = ps: [ ps.pgvector ];
        ensureDatabases = [ dbName ];
        ensureUsers = [
          {
            name = "silo";
            ensureDBOwnership = true;
          }
        ];
      };

      # Silo's first migration runs `CREATE EXTENSION IF NOT EXISTS vector`, but
      # the unprivileged `silo` role cannot create extensions. Create it here as
      # the postgres superuser so the migration finds it already present. Hooked
      # onto postgresql-setup (which creates the silo database first and runs
      # psql as the postgres superuser); silo orders after postgresql.service.
      systemd.services.postgresql-setup.postStart = lib.mkAfter ''
        psql -d ${dbName} -tAc 'CREATE EXTENSION IF NOT EXISTS vector;'
      '';

      services.redis.servers.silo = {
        enable = true;
        port = redisPort;
        bind = "127.0.0.1";
      };

      systemd.tmpfiles.rules = [
        "d ${dataDir} 0750 silo silo - -"
      ];

      networking.firewall.allowedTCPPorts = [
        port
        jellyfinPort
      ];

      systemd.services.silo = {
        description = "Silo media server";
        documentation = [ "https://github.com/Silo-Server/silo-server" ];
        after = [
          "network-online.target"
          "postgresql.service"
          "postgresql-setup.service"
          "redis-silo.service"
        ];
        wants = [
          "network-online.target"
          "postgresql.service"
          "postgresql-setup.service"
          "redis-silo.service"
        ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          MODE = "integrated";
          PORT = toString port;
          JF_PORT = toString jellyfinPort;
          ABS_PORT = toString audiobookshelfPort;
          DATABASE_URL = databaseUrl;
          REDIS_URL = redisUrl;
          SECRET_KEY = secrets.silo.secretKey;
          HOME = dataDir;
        };

        serviceConfig = {
          Type = "simple";
          User = "silo";
          Group = "silo";
          ExecStart = lib.getExe silo;
          Restart = "on-failure";
          RestartSec = 5;

          # On stop, Silo drains in-flight requests then shuts down its embedded
          # datastores, which can take a little while.
          TimeoutStopSec = 120;

          StateDirectory = "silo";
          StateDirectoryMode = "0750";
          WorkingDirectory = dataDir;

          # Hardening — Silo needs its state dir and the network. ProtectSystem
          # blocks writes outside the state dir; media is read from the host.
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = [ dataDir ];
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          LockPersonality = true;
        };
      };
    };
}
