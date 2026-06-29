{ _, ... }:
{
  flake.modules.nixos.boot =
    { pkgs, ... }:
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
    };
}
