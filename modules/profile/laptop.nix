{ self, ... }:
{
  flake.modules.nixos.profiles-laptop =
    { inputs, features, ... }:
    {
      imports = with self.modules.nixos; [
        profiles-desktop
        services-tlp
        services-upower
        system-sleep
      ];

      powerManagement = {
        enable = true;
        powertop.enable = true;
      };

      services.logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
      };
    };

  flake.modules.homeManager.profiles-laptop =
    { inputs, ... }:
    {
      imports = with self.modules.homeManager; [
        profiles-desktop
      ];
    };
}
