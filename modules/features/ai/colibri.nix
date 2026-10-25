_: {
  # colibrì — run large MoE models in pure C, experts streamed from disk.
  # https://github.com/JustVugg/colibri
  #
  # Upstream's flake builds a CPU/Metal engine only. This module rebuilds it
  # with the Vulkan backend (VK=1) so the GPU — including AMD integrated GPUs
  # like the Radeon 780M (gfx1103) — is used. Vulkan is colibri's recommended
  # path for iGPUs and for AMD parts ROCm doesn't cover, and it works on NVIDIA
  # too, so one portable GPU build serves every `hardware.gpu` here.
  #
  # Model download and setup (`coli setup`, 19GB+, needs consent/network/disk)
  # are deliberately NOT done declaratively — run it once by hand per
  # docs/AI_SETUP.md:
  #
  #   sudo -u colibri COLI_SETUP_HOME=/var/lib/colibri \
  #     coli setup --yes --backend vulkan --model <id> --no-start
  #
  # then `systemctl start colibri`. See `coli setup --list` for model ids.
  flake-file.inputs.colibri = {
    url = "github:JustVugg/colibri";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.colibri =
    {
      pkgs,
      lib,
      hardware,
      features,
      ...
    }:
    let
      cfg = features.colibri or { };

      hasGpu = hardware.hasNvidia || hardware.hasAMDGPU;
      # Build the Vulkan backend whenever a GPU is present, unless overridden.
      withVulkan = cfg.vulkan or hasGpu;

      # The package (Vulkan rebuild + staged web dashboard) is defined in
      # pkgs/colibri.nix and exposed via self.overlays.packages. The
      # module only picks the GPU-appropriate backend for this host.
      colibri = pkgs.colibri.override { inherit withVulkan; };

      host = cfg.host or "127.0.0.1";
      port = toString (cfg.port or 8000);

      # Where `coli setup` writes setup.json, logs, models config, etc.
      setupHome = "/var/lib/colibri";
    in
    {
      # The Vulkan build needs the loader + an ICD at runtime; NixOS exposes
      # them under /run/opengl-driver/lib when graphics support is enabled.
      hardware.graphics.enable = lib.mkIf withVulkan true;

      environment.systemPackages = [ colibri ];

      users.users.colibri = {
        isSystemUser = true;
        group = "colibri";
        home = setupHome;
      };
      users.groups.colibri = { };

      systemd.services.colibri = {
        description = "colibrì MoE inference server";
        documentation = [ "https://github.com/JustVugg/colibri/blob/main/docs/AI_SETUP.md" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        # The one-time `coli setup` (download + consent) cannot run during a
        # Nix build/activation, so it is done manually (see header). Until it
        # has written setup.json, this condition keeps the unit *skipped* — not
        # failed — so the first system activation and every boot before setup
        # stay clean. Once setup.json exists the service auto-starts on boot.
        unitConfig.ConditionPathExists = "${setupHome}/setup.json";

        environment = {
          COLI_SETUP_HOME = setupHome;
          HOME = setupHome;
        };

        # `coli start` runs the server the previous `coli setup` configured.
        # It refuses to start if setup has not been run yet, so this service
        # is a no-op until the operator completes the one-time setup above.
        serviceConfig = {
          Type = "simple";
          User = "colibri";
          Group = "colibri";
          ExecStart = "${lib.getExe colibri} start --host ${host} --port ${port} --no-browser";
          ExecStop = "${lib.getExe colibri} stop";
          Restart = "on-failure";
          RestartSec = 5;

          StateDirectory = "colibri";
          StateDirectoryMode = "0750";
          WorkingDirectory = setupHome;

          # GPU access: the render node and the Vulkan ICD/driver.
          SupplementaryGroups = lib.mkIf withVulkan [
            "render"
            "video"
          ];
          DeviceAllow = lib.mkIf withVulkan [
            "/dev/dri rw"
            "char-drm rw"
          ];

          # Hardening — colibri only needs its state dir, the GPU and the network.
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ReadWritePaths = [ setupHome ];
          PrivateDevices = lib.mkDefault (!withVulkan);
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
