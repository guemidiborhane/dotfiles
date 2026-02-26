{ _, ... }:
{
  flake.nixosModules.default-pkgs =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        inputs-nur
      ];
    };
}
