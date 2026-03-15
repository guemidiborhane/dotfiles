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
      };
      systemd.sleep.settings.Sleep = {
        AllowSuspend = "yes";
        AllowHibernation = "yes";
        AllowSuspendThenHibernate = "yes";
        AllowHybridSleep = "no";
        SuspendState = "freeze";
        HibernateMode = "shutdown";
        HibernateState = "disk";
        HybridSleepState = "disk";
        HibernateDelaySec = "45min";
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
