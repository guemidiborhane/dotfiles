{ _, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia-shell/legacy-v4";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.substituters.noctalia-shell = {
    url = "https://noctalia.cachix.org";
    key = "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=";
  };

  flake.modules.homeManager.noctalia =
    {
      inputs,
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        inputs.noctalia.homeModules.default
        ./_configs
      ];

      programs.noctalia-shell = {
        enable = true;
        package = pkgs.noctalia-shell;
      };

      systemd.user.services.noctalia-shell =
        let
          cfg = config.programs.noctalia-shell;
        in
        {
          Unit = {
            Description = "Noctalia Shell - Wayland desktop shell";
            Documentation = "https://docs.noctalia.dev";
            PartOf = [ config.wayland.systemd.target ];
            After = [ config.wayland.systemd.target ];
          };

          Service = {
            Environment = "QT_QPA_PLATFORMTHEME=gtk3";
            ExecStart = lib.getExe cfg.package;
            Restart = "on-failure";
          };

          Install.WantedBy = [ config.wayland.systemd.target ];
        };
    };
}
