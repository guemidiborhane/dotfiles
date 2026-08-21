{ _, ... }:
{
  flake-file.inputs.nixos-hardware.url = "github:NixOs/nixos-hardware/master";
  flake.modules.nixos.nixos-hardware =
    { lib, hardware, inputs, ... }:
    {
      imports = [ inputs.nixos-hardware.nixosModules."${hardware.module}" ];
    };
}
