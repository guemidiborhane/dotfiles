{ lib, ... }:
{
  programs.sesh = {
    enable = true;
    enableTmuxIntegration = false; # already handled
  };

  home.file.".config/sesh/sesh.toml".enable = lib.mkForce false;
}
