{ _, ... }:
{
  flake.modules.nixos.base-devel =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gcc
        gnumake
        libyaml
        libxml2
        libffi
        pkg-config
        sqlite
      ];

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        libyaml
        libxml2
        libffi
        openssl
        sqlite
      ];

      services.locate = {
        enable = true;
        package = pkgs.plocate;
        interval = "hourly";
      };
    };
}
