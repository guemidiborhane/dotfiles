{ _, ... }:
{
  flake.nixosModules.profiles-laptop =
    { inputs, features, ... }:
    {
      imports = [
        inputs.self.nixosModules.profiles-desktop
        inputs.self.nixosModules.services-tlp
        inputs.self.nixosModules.services-upower
      ];

      powerManagement = {
        enable = true;
        powertop.enable = true;
      };

      services.logind.settings.Login = {
        HandleLidSwitch = "suspend-then-hibernate";
        HibernateDelaySec = "30min";
      };
    };

  flake.homeModules.profiles-laptop =
    { inputs, ... }:
    {
      imports = with inputs.self.homeModules; [
        profiles-desktop
      ];
    };
}
