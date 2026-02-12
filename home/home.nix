{ cfg, user, ... }:
{
  home = {
    enableNixpkgsReleaseCheck = true;
    username = "${user.username}";
    homeDirectory = "/home/${user.username}";
    inherit (cfg.metadata) stateVersion;
  };
}
