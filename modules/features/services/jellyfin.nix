{ _, ... }:
{
  flake.modules.nixos.jellyfin =
    ctx@{ lib, pkgs, ... }:
    let
      types = {
        nvidia = "nvenc";
        amd = "vaapi";
      };
    in
    with ctx;
    lib.mkIf (features.jellyfin or false) {
      services.jellyfin = {
        enable = true;
        openFirewall = true;

        hardwareAcceleration = {
          enable = true;
          type = types.${hardware.gpu};
          device = "/dev/dri/renderD128";
        };
      };
      environment.systemPackages = (host.extraPkgs or [ ]) ++ [ pkgs.jellyfin-mpv-shim ];
    };
}
