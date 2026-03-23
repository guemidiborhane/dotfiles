{ self, ... }:
{
  flake.nixosModules.profiles-laptop =
    { inputs, features, ... }:
    {
      imports = [
        self.nixosModules.profiles-desktop
        self.nixosModules.services-tlp
        self.nixosModules.services-upower
        self.nixosModules.system-sleep
      ];

      powerManagement = {
        enable = true;
        powertop.enable = true;
      };

      services.logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
      };
    };

  flake.homeModules.profiles-laptop =
    { inputs, ... }:
    {
      imports = with self.homeModules; [
        profiles-desktop
      ];
    };
}
