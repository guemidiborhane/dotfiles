{ _, ... }:
{
  flake.modules.nixos.programs-neovim = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
