{ self, ... }:
{
  flake.modules.nixos.host-profile =
    { inputs, host, ... }:
    {
      imports = [
        self.modules.nixos."profiles-${host.type}"
      ];
    };

  flake.modules.homeManager.host-profile =
    { inputs, host, ... }:
    {
      imports = [
        self.modules.homeManager."profiles-${host.type}"
      ];
    };
}
