{ pkgs, ... }:
{
  programs.nix-ld.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "hourly";
  };
}
