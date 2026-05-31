{ _, ... }:
{
  flake.modules.homeManager.git-crypt =
    {
      pkgs,
      user,
      config,
      ...
    }:
    {
      home.packages = [ pkgs.git-crypt ];
      xdg.configFile."git/allowed-signers".text = ''
        ${user.email} ${user.signingKey}
      '';
      programs.git.iniContent.gpg.ssh = {
        allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed-signers";
      };
    };
}
