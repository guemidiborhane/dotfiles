{ _, ... }:
{
  flake.nixosModules.host-profile =
    { inputs, host, ... }:
    {
      imports = [
        inputs.self.nixosModules."profiles-${host.type}"
      ];
    };

  flake.homeModules.host-profile =
    { inputs, host, ... }:
    {
      imports = [
        inputs.self.homeModules."profiles-${host.type}"
      ];
    };
}
