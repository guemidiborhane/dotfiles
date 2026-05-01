{ _, ... }:
{
  flake.modules.nixos.common-host-configs =
    { lib, pkgs, ... }:
    {
      boot = {
        kernel.sysctl = {
          "vm.swappiness" = 10;
        };
        initrd.systemd.enable = true;
        loader = {
          timeout = 0;
          efi.canTouchEfiVariables = true;
          systemd-boot = {
            enable = true;
            memtest86.enable = builtins.elem pkgs.stdenv.hostPlatform.system pkgs.memtest86plus.meta.platforms;
          };
        };
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

      programs.gnupg.agent.enable = true;
      environment.shellAliases.ls = lib.mkForce null;
    };
}
