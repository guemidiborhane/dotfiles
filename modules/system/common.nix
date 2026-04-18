{ _, ... }:
{
  flake.modules.nixos.common-host-configs =
    { lib, pkgs, ... }:
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
    };
}
