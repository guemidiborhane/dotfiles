{ _, ... }:
{
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        neovim
        ripgrep
        fd
        nodejs
      ];

      dex.dotfiles.".config/nvim" = ./.;

      programs.fish.shellAliases = {
        vf = "fd --type f | fzf-tmux -p --reverse --preview 'bat -p --color=always {}' | xargs -r nvim";
        v = "nvim";
        vi = "nvim";
        vim = "nvim";
      };
    };
}
