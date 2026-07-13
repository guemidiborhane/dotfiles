{ _, ... }:
{
  flake.unfreePackages = [
    "steam"
    "steam-unwrapped"
  ];

  flake.modules.nixos.gaming =
    ctx@{ lib, pkgs, ... }:
    lib.mkIf (ctx.features.gaming or false) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      programs.gamemode.enable = true;
      environment.systemPackages = with pkgs; [
        lutris
        protonup-qt
      ];
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    };
}
