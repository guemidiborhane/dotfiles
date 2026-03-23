{ self, ... }:
{
  flake.nixosModules.host-profile =
    { inputs, host, ... }:
    {
      imports = [
        self.nixosModules."profiles-${host.type}"
      ];
    };

  flake.homeModules.host-profile =
    { inputs, host, ... }:
    {
      imports = [
        self.homeModules."profiles-${host.type}"
      ];
    };
}
