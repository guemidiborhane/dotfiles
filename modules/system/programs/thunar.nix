{ _, ... }:
{
  flake.modules.nixos.thunar =
    { pkgs, ... }:
    {
      programs.xfconf.enable = true;
      services.gvfs.enable = true; # Mount, trash, and other functionalities
      services.tumbler.enable = true; # Thumbnail support for images
      programs.thunar = {
        enable = true;
        plugins = with pkgs.unstable; [
          thunar-volman
          thunar-archive-plugin
        ];
      };
    };
}
