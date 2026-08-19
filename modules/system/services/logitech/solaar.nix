{ _, ... }:
{
  flake.modules.nixos.solaar =
    { inputs, ... }:
    {
      programs.solaar = {
        enable = false;
        userService = {
          enable = true;
          extraArgs = [
            "--tray-icon-size 32"
            "--restart-on-wake-up"
          ];
        };
      };
    };

  flake.modules.homeManager.solaar =
    { inputs, ... }:
    {
      programs.git.settings.filter = {
        "ignore_solaar_cookie_key" = {
          clean = "sed '/_config_cookie:/d'";
        };
      };
    };
}
