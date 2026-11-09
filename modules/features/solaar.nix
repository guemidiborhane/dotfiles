_: {
  flake.modules.nixos.solaar =
    { features, ... }:
    {
      programs.solaar = {
        # Mutually exclusive with openlogi; selected via features.logitech.
        enable = features.logitech == "solaar";
        userService = {
          enable = true;
          extraArgs = [
            "--tray-icon-size 32"
            "--restart-on-wake-up"
          ];
        };
      };
    };

  # The git clean filter is harmless regardless of which Logitech tool is
  # active, so it is always applied.
  flake.modules.homeManager.solaar = _: {
    programs.git.settings.filter = {
      "ignore_solaar_cookie_key" = {
        clean = "sed '/_config_cookie:/d'";
      };
    };
  };
}
