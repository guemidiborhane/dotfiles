{ _, ... }:
{
  flake.nixosModules.programs-nh = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep-since 7d --keep 3";
      };
      flake = "/etc/nixos";
    };
  };
}
