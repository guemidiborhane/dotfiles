{ _, ... }:
{
  flake.modules.homeManager.programs-eza =
    { config, lib, ... }:
    {
      programs.eza = {
        enable = true;
        colors = "auto";
        icons = "auto";
        extraOptions = [
          "--group-directories-first"
        ];
      };

      # source: https://denshub.com/en/best-ls-command-alternative/#first-time
      programs.fish.shellAliases = {
        ld = "eza -lD";
        lf = "eza -lF";
        ll = "eza -al";
        lt = "eza -al --sort=modified";
      };
    };
}
