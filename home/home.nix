{
  pkgs,
  cfg,
  inputs,
  ...
}:
{
  home = {
    enableNixpkgsReleaseCheck = true;
    username = "${cfg.user.username}";
    homeDirectory = "/home/${cfg.user.username}";
    inherit (cfg.metadata) stateVersion;
  };
}
