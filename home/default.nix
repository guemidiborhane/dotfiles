{ inputs, host, ... }:
{
  imports = [
    inputs.nur.modules.homeManager.default

    ./home.nix
    ./pkgs.nix
    ./modules/git.nix
    ./modules/yadm.nix
    ./modules/shell.nix
    ./modules/programs/yadm.nix
    ./profiles/${host.type}.nix
  ];

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };
  programs.home-manager.enable = true;
}
