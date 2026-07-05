{ self, ... }:
{
  flake.modules.nixos.default-programs =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        nh
        neovim
        fish
      ];
    };
}
