{ _, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.substituters.noctalia = [
    {
      url = "https://noctalia.cachix.org";
      key = "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=";
    }
  ];

  flake.modules.homeManager.programs-noctalia =
    { inputs, pkgs, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia-shell = {
        enable = true;
        package = pkgs.noctalia-shell;
        systemd.enable = true;
      };

      systemd.user.services.noctalia-shell.Service.Environment = "QT_QPA_PLATFORMTHEME=gtk3";
    };
}
