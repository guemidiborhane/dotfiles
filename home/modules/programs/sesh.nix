{ lib, ... }:
{
  programs.sesh = {
    enable = true;
    enableTmuxIntegration = false; # already handled
  };

  home.file."sesh/sesh.toml".enable = lib.mkForce false;
}
