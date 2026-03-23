{ self, ... }:
{
  flake.nixosModules.default-pkgs =
    { inputs, ... }:
    {
      imports = with self.nixosModules; [
        inputs-nur
      ];
    };
}
