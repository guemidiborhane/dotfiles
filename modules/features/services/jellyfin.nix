_: {
  flake.modules.nixos.jellyfin =
    {
      pkgs,
      hardware,
      host,
      ...
    }:
    let
      types = {
        nvidia = "nvenc";
        amd = "vaapi";
        intel = "vaapi";
      };
    in
    {
      services.jellyfin = {
        enable = true;
        openFirewall = true;

        hardwareAcceleration = {
          enable = true;
          type = types.${hardware.gpu} or "vaapi";
          device = "/dev/dri/renderD128";
        };
      };
      environment.systemPackages = (host.extraPkgs or [ ]) ++ [ pkgs.jellyfin-mpv-shim ];
    };
}
