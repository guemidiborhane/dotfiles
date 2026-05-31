{ _, ... }:
{
  flake.modules.homeManager.mise =
    { _, ... }:
    {
      programs.mise.enable = true;
      dex.dotfiles.".config/mise/config.toml" = ./config.toml;
    };
}
