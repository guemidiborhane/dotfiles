{ _, ... }:
{
  flake.modules.homeManager.gaming =
    {
      lib,
      features,
      pkgs,
      ...
    }:
    lib.mkIf (features.gaming or false) {
      home.packages = with pkgs; [
        lutris
        protonup-qt
      ];
    };
}
