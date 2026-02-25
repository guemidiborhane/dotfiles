{ metadata, user, ... }:
{
  home = {
    inherit (metadata) stateVersion;

    enableNixpkgsReleaseCheck = true;
    username = "${user.username}";
    homeDirectory = "/home/${user.username}";
  };
}
