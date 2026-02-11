{ pkgs, inputs, ... }:
{
  programs.vicinae = {
    enable = true;
    package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;

    useLayerShell = true;
    extensions = [ ];

    systemd = {
      enable = true;
      autoStart = true;
      target = "user-graphical-session.target";
    };
  };
}
