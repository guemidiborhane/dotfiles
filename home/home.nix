{ pkgs, cfg, ... }:
{
  enableNixpkgsReleaseCheck = true;
  username = "${cfg.user.username}";
  homeDirectory = "/home/${cfg.user.username}";

  packages = import ./pkgs.nix { inherit pkgs; };

  inherit (cfg.metadata) stateVersion;
}
