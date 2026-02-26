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

      services.libinput.enable = features.touchpad;
      services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";

      programs.light.enable = features.backlight;
    };

  flake.homeModules.profiles-laptop =
    { inputs, ... }:
    {
      imports = with inputs.self.homeModules; [
        profiles-desktop
        services-hyprpaper
        services-hyprpower
      ];
    };
}
