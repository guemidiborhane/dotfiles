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
  # cannot run during a Nix build/activation, so it is done once by hand. Use
  # the `colibri-setup` wrapper this module installs — it runs setup as the
  # service user with the right environment, pins the backend, and applies the
  # configured host/port, so you only pick a model:
  #
  #   sudo colibri-setup --model <id>
  #
  # then `systemctl start colibri`. `colibri-setup --list` shows the model ids,
  # and any extra flags (e.g. --reconfigure) are forwarded to `coli setup`.
  #
  # host/port are declarative: features.colibri.host/.port feed both the wrapper
  # and an ExecStartPre that re-applies them on every start (since `coli start`
  # itself has no --host/--port and reads setup.json). Changing them in config
  # and restarting the service is enough — no manual re-setup.
  #
  # The backend is pinned to vulkan on a GPU host (cpu otherwise): left to
  # `auto`, colibri picks CUDA first on an NVIDIA card and then falls back to
  # the CPU, since the CUDA toolkit is not in this engine's build. If an earlier
  # run already recorded CPU (`engine ready: … (cpu, present)`, or `no Vulkan
  # GPU answered`), clear setup.json before re-running so the pin takes:
  #
  #   sudo rm -f /var/lib/colibri/setup.json && sudo colibri-setup --model <id>
  #
  # Setup must run through THIS package's wrapped `coli` (which `colibri-setup`
  # uses): the wrapper exposes the Vulkan loader and ICD to the Python GPU probe
  # (see pkgs/colibri.nix). A bare upstream `coli`, or a stripped environment,
  # makes the probe report "no Vulkan GPU answered" and fall back to the CPU
  # even though the card is present.
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

      # Where `coli setup` writes setup.json, logs, models config, etc.
      setupHome = "/var/lib/colibri";

      # The server address. `coli start` has no --host/--port; it serves on
      # whatever `coli setup` recorded in setup.json, so these values are the
      # single source of truth — applied by the setup wrapper and re-applied on
      # every service start (ExecStartPre), which makes them declarative.
      host = cfg.host or "127.0.0.1";
      port = toString (cfg.port or 8000);

      # The backend `coli setup` must pin. On a GPU host leaving this to `auto`
      # lets colibri try CUDA (unbuildable here) and fall back to CPU, so force
      # vulkan; a CPU-only host uses cpu.
      backend = if withVulkan then "vulkan" else "cpu";

      # The common `coli setup` invocation, shared by the manual wrapper and the
      # ExecStartPre that keeps host/port/backend in sync with this config.
      # --no-start leaves starting to systemd, and re-running it on a finished
      # setup only rewrites setup.json (the model is already downloaded, so
      # nothing is fetched again). --yes is NOT here: the interactive wrapper
      # should prompt (for the download consent on first run), while the
      # ExecStartPre adds --yes itself to stay non-interactive.
      coliSetupArgs = "setup --backend ${backend} --host ${host} --port ${port} --no-start";

      # `colibri-setup` — a thin, friendlier replacement for the long
      # `sudo -u colibri COLI_SETUP_HOME=… coli setup …` line. It runs the setup
      # as the service user with the right environment and sane defaults, and
      # forwards any extra arguments (most importantly --model <id>, or
      # --list / --reconfigure, or --yes for an unattended run). It is
      # interactive on purpose, so the first run prompts for the download
      # consent. Run it as root: `sudo colibri-setup --model <id>`.
      colibriSetup = pkgs.writeShellApplication {
        name = "colibri-setup";
        runtimeInputs = [ pkgs.util-linux ];
        text = ''
          if [ "$(id -u)" -ne 0 ]; then
            echo "colibri-setup: must run as root (it drops to the colibri user)" >&2
            exit 1
          fi
          # runuser keeps a clean login-like env but lets us pin COLI_SETUP_HOME;
          # the wrapped `coli` adds the Vulkan loader/ICD paths itself.
          exec runuser -u colibri -- \
            env COLI_SETUP_HOME=${setupHome} HOME=${setupHome} \
            ${lib.getExe colibri} ${coliSetupArgs} "$@"
        '';
      };
    in
    {
      # The Vulkan build needs the loader + an ICD at runtime; NixOS exposes
      # them under /run/opengl-driver/lib when graphics support is enabled.
      hardware.graphics.enable = lib.mkIf withVulkan true;

      environment.systemPackages = [
        colibri
        colibriSetup
      ];

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

        # No LD_LIBRARY_PATH / XDG_DATA_DIRS here: the `coli` launcher is wrapped
        # in the package to carry the Vulkan loader and the ICD search path (see
        # pkgs/colibri.nix), so both this service and a manual `coli setup` get
        # the same GPU environment. Setting them here too would only duplicate
        # what the wrapper already prepends.
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
          # Re-apply host/port/backend from this config before starting. `coli
          # start` has no --host/--port — it reads setup.json — so this is what
          # makes features.colibri.host/.port declarative: on a completed setup,
          # re-running `coli setup` with these flags only rewrites setup.json
          # (the model is already downloaded, nothing is fetched), then start
          # serves on the updated address. It no-ops when nothing changed.
          # --yes keeps it non-interactive (the manual wrapper omits it so a
          # first run can prompt for the download consent).
          ExecStartPre = "${lib.getExe colibri} ${coliSetupArgs} --yes";
          # `coli start` takes no --host/--port; it serves on the host and port
          # setup.json now holds. Run in the foreground (no --background) so
          # systemd owns the process.
          ExecStart = "${lib.getExe colibri} start --no-browser";
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
