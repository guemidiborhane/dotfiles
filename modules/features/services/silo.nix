{ lib, ... }:
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
  # This module builds the native server (pkgs/silo.nix) and provisions its
  # datastores: PostgreSQL with the pgvector extension and Redis.
  #
  # Configurable via features.silo: enable, port, jellyfinPort. Everything else
  # is fixed below; the SECRET_KEY comes from secrets.silo.secretKey.
  flake.modules.nixos.silo =
    {
      pkgs,
      secrets,
      features,
      ...
    }:
    let
      cfg = features.silo;

      inherit (pkgs) silo;

      port = cfg.port or 8090;
      jellyfinPort = cfg.jellyfinPort or 8096;
      audiobookshelfPort = 13378;

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
      environment.systemPackages = [ silo ];

      users.users.silo = {
        isSystemUser = true;
        group = "silo";
        home = dataDir;
      };
      users.groups.silo = { };

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
