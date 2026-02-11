{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    libyaml
    libxml2
    libffi
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libyaml
    libxml2
    libffi
  ];

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "hourly";
  };
}
