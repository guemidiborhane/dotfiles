{ _, ... }:
{
  flake.modules.homeManager.programs-ghostty =
    { _, ... }:
    {
      programs.ghostty = {
        enable = false;
        systemd.enable = true;

        installVimSyntax = true;
        installBatSyntax = true;
      };
    };
}
