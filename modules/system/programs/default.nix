{ self, ... }:
{
  flake.modules.nixos.default-programs =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        programs-nh
        programs-neovim
        programs-fish
      ];
    };
}
