{ pkgs, cfg, inputs, ... }:
{
  enableNixpkgsReleaseCheck = true;
  username = "${cfg.user.username}";
  homeDirectory = "/home/${cfg.user.username}";

  packages = import ./pkgs.nix { inherit pkgs inputs; };

  inherit (cfg.metadata) stateVersion;
}
