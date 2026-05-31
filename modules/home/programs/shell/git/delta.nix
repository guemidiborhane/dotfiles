{ _, ... }:
{
  flake.modules.homeManager.delta =
    { _, ... }:
    {
      programs.delta = {
        enable = true;
        enableGitIntegration = true;
      };
    };
}
