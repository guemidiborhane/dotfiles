{ _, ... }:
{
  flake.modules.homeManager.home-config =
    { metadata, user, ... }:
    {
      programs.home-manager.enable = true;
      home = {
        inherit (metadata) stateVersion;

        enableNixpkgsReleaseCheck = true;
        username = "${user.username}";
        homeDirectory = "/home/${user.username}";
      };
    };
}
