{ _, ... }:
{
  flake.nixosModules.common-host-configs =
    {
      lib,
      pkgs,
      features,
      metadata,
      ...
    }:
    {
      boot.loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          memtest86.enable = builtins.elem pkgs.stdenv.hostPlatform.system pkgs.memtest86plus.meta.platforms;
        };
      };

      boot.kernel.sysctl = {
        "vm.swappiness" = 10;
      };

      zramSwap = {
        enable = features.zramSwap;
        priority = 100;
        algorithm = "lz4";
        memoryPercent = 30;
      };

      security = {
        polkit.enable = true;
        sudo = {
          extraConfig = ''
            Defaults passwd_timeout=5
            Defaults insults
          '';
        };
      };

      environment.shellAliases.ls = lib.mkForce null;
      system.stateVersion = metadata.stateVersion;
    };
}
