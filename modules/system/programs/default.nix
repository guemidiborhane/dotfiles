{ _, ... }:
{
  flake.nixosModules.default-programs =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        programs-nh
        programs-neovim
        programs-fish
      ];
    };
}
