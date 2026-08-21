{ self, ... }:
{
  flake.modules.nixos.laptop-profile =
    { inputs, features, ... }:
    {
      imports = with self.modules.nixos; [ desktop-profile ];

      powerManagement.enable = true;
      services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
      services.upower = {
        enable = true;
        criticalPowerAction = "HybridSleep";
      };
    };

  flake.modules.homeManager.laptop-profile =
    { inputs, ... }:
    {
      imports = with self.modules.homeManager; [ desktop-profile ];
    };
}
