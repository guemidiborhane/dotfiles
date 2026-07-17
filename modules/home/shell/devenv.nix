{ _, ... }:
{
  flake.caches.devenv = {
    url = "https://devenv.cachix.org";
    key = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
  };

  flake.modules.homeManager.devenv =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.devenv ];
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
