{ _, ... }:
{
  flake.modules.homeManager.programs-direnv =
    { _, ... }:
    {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
