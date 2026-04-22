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
            X-Restart-Triggers =
              lib.optional (cfg.settings != { }) "${config.xdg.configFile."noctalia/settings.json".source}"
              ++ lib.optional (cfg.colors != { }) "${config.xdg.configFile."noctalia/colors.json".source}"
              ++ lib.optional (cfg.plugins != { }) "${config.xdg.configFile."noctalia/plugins.json".source}"
              ++ lib.mapAttrsToList (
                name: _: "${config.xdg.configFile."noctalia/plugins/${name}/settings.json".source}"
              ) cfg.pluginSettings;
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
