{ self, lib, ... }:
{
  flake.dex.apps.jellyfin = {
    module = self.modules.nixos.jellyfin-service;
    gpu = true;
    external = true;
    ports = [
      { host = 8096; }
      { host = 8920; }
    ];
    # Media lives on the host disks declared in hardware.mounts; mount each at
    # the same path inside the container (read-only) so jellyfin serves it.
    mounts =
      ctx: lib.mapAttrs' (_uuid: path: lib.nameValuePair path path) (ctx.hardware.mounts or { });
  };

  flake.modules.nixos.jellyfin-service =
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
