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
      inputs,
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

      base = inputs.colibri.packages.${pkgs.stdenv.hostPlatform.system}.colibri;

      # Rebuild upstream's derivation with VK=1. `make install` stages the
      # engines under $out/lib/colibri but NOT the SPIR-V shaders, and the
      # engines look for them in ./shaders next to the binary — so copy them
      # there. The Vulkan loader is dlopen'd at runtime (not linked), so it is
      # added to the wrapped LD_LIBRARY_PATH alongside /run/opengl-driver/lib,
      # which NixOS populates with the Mesa/driver Vulkan ICD when
      # hardware.graphics.enable is set.
      colibriVulkan = base.overrideAttrs (prev: {
        pname = "colibri-vulkan";

        # glslc lives in shaderc's split `bin` output, not the default `out`.
        nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ pkgs.shaderc.bin ];
        buildInputs = (prev.buildInputs or [ ]) ++ [
          pkgs.vulkan-headers
          pkgs.vulkan-loader
        ];

        buildPhase = ''
          runHook preBuild
          make -C c install VK=1 GLSLC=${pkgs.shaderc.bin}/bin/glslc \
            ARCH=x86-64-v3 \
            DESTDIR=$out PREFIX= BINDIR=/bin LIBEXECDIR=/lib/colibri
          # Stage the compiled shaders beside the engines; `make install`
          # omits them and the default lookup is ./shaders next to the binary.
          install -d $out/lib/colibri/shaders
          install -m 644 c/shaders/*.spv $out/lib/colibri/shaders/
          runHook postBuild
        '';

        # The engines dlopen libvulkan.so.1 by soname at runtime. Make the
        # loader + ICD findable: $out/bin/coli (the makeWrapper the base
        # installPhase created) is re-wrapped so its engine subprocesses
        # inherit LD_LIBRARY_PATH; the engine's own $out/bin/colibri symlink
        # resolves to $out/lib/colibri/colibri, so wrap that directly.
        postFixup = (prev.postFixup or "") + ''
          wrapProgram $out/bin/coli \
            --suffix LD_LIBRARY_PATH : "${pkgs.vulkan-loader}/lib:/run/opengl-driver/lib"
          wrapProgram $out/lib/colibri/colibri \
            --suffix LD_LIBRARY_PATH : "${pkgs.vulkan-loader}/lib:/run/opengl-driver/lib"
        '';
      });

      # The dashboard (web/dist) is a build artifact upstream's derivation
      # doesn't produce, so `coli setup` tries to fetch it and copy it into
      # $out at runtime — impossible in the store. Build it here and stage it
      # at lib/colibri/web/dist, the first path both setup_flow.py and
      # openai_server.py probe; ensure_web_dist() then returns early.
      colibriWeb = pkgs.buildNpmPackage {
        pname = "colibri-web";
        version = base.version;
        src = inputs.colibri + "/web";
        npmDepsHash = "sha256-dSBj0ugEctPY18JWe5ajsVQFy2kWvgLYLzuwIs39HLs="; # replace with the hash from the first build error
        installPhase = ''
          runHook preInstall
          cp -r dist $out
          runHook postInstall
        '';
      };

      withWeb =
        drv:
        drv.overrideAttrs (prev: {
          postInstall = (prev.postInstall or "") + ''
            install -d $out/lib/colibri/web
            cp -r ${colibriWeb} $out/lib/colibri/web/dist
          '';
        });

      colibri = withWeb (if withVulkan then colibriVulkan else base);

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

      # systemd.services.colibri = {
      #   description = "colibrì MoE inference server";
      #   documentation = [ "https://github.com/JustVugg/colibri/blob/main/docs/AI_SETUP.md" ];
      #   after = [ "network-online.target" ];
      #   wants = [ "network-online.target" ];
      #   wantedBy = [ "multi-user.target" ];
      #
      #   environment = {
      #     COLI_SETUP_HOME = setupHome;
      #     HOME = setupHome;
      #   };
      #
      #   # `coli start` runs the server the previous `coli setup` configured.
      #   # It refuses to start if setup has not been run yet, so this service
      #   # is a no-op until the operator completes the one-time setup above.
      #   serviceConfig = {
      #     Type = "simple";
      #     User = "colibri";
      #     Group = "colibri";
      #     ExecStart = "${lib.getExe colibri} start --host ${host} --port ${port} --no-browser";
      #     ExecStop = "${lib.getExe colibri} stop";
      #     Restart = "on-failure";
      #     RestartSec = 5;
      #
      #     StateDirectory = "colibri";
      #     StateDirectoryMode = "0750";
      #     WorkingDirectory = setupHome;
      #
      #     # GPU access: the render node and the Vulkan ICD/driver.
      #     SupplementaryGroups = lib.mkIf withVulkan [
      #       "render"
      #       "video"
      #     ];
      #     DeviceAllow = lib.mkIf withVulkan [
      #       "/dev/dri rw"
      #       "char-drm rw"
      #     ];
      #
      #     # Hardening — colibri only needs its state dir, the GPU and the network.
      #     NoNewPrivileges = true;
      #     PrivateTmp = true;
      #     ProtectSystem = "strict";
      #     ProtectHome = true;
      #     ReadWritePaths = [ setupHome ];
      #     PrivateDevices = lib.mkDefault (!withVulkan);
      #     ProtectKernelTunables = true;
      #     ProtectKernelModules = true;
      #     ProtectControlGroups = true;
      #     RestrictAddressFamilies = [
      #       "AF_INET"
      #       "AF_INET6"
      #       "AF_UNIX"
      #     ];
      #     RestrictNamespaces = true;
      #     LockPersonality = true;
      #   };
      # };
    };
}
