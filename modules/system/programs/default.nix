{ self, ... }:
{
  flake.nixosModules.default-programs =
    { inputs, ... }:
    {
      imports = with self.nixosModules; [
        programs-nh
        programs-neovim
        programs-fish
      ];
    };
}
