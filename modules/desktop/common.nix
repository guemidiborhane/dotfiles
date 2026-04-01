{ _, ... }:
{
  flake.homeModules.desktop-common =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      gtk =
        let
          theme = {
            package = pkgs.dracula-theme;
            name = "Dracula";
          };
        in
        {
          enable = true;

          inherit theme;
          gtk4 = { inherit theme; };

          iconTheme = {
            package = pkgs.kora-icon-theme;
            name = "kora";
          };

          font = {
            package = pkgs.cantarell-fonts;
            name = "Cantarell";
            size = 11;
          };

          gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = true;
          };
        };

      dconf = {
        enable = true;
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
      };

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = false;
          desktop = "${config.home.homeDirectory}/Desktop";
          documents = "${config.home.homeDirectory}/Documents";
          download = "${config.home.homeDirectory}/Downloads";
          music = "${config.home.homeDirectory}/Music";
          pictures = "${config.home.homeDirectory}/Pictures";
          videos = "${config.home.homeDirectory}/Videos";
          extraConfig = {
            CODE = "${config.home.homeDirectory}/Code";
          };
        };
        configFile = {
          "swaync/config.json".enable = lib.mkForce false;
          "swaync/style.json".enable = lib.mkForce false;
        };
      };
    };
}
