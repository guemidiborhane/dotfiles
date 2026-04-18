{ self, ... }:
{
  flake.modules.nixos.default-pkgs =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        inputs-nur
      ];
    };
}
