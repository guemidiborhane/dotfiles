{ _, ... }:
{
  flake.homeModules.programs-ghostty =
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
