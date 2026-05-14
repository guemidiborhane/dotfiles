{ _, ... }:
{
  flake.modules.homeManager.services-hypower =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      hypower = pkgs.writeShellScriptBin "hypower" (builtins.readFile ./scripts/hypower.sh);
    in
    {

      options.services.hypower = {
        enabled = lib.mkEnableOption "Hyprland power profile switcher";
      };

      config = lib.mkIf config.services.hypower.enabled {
        home.packages = [
          pkgs.upower
          hypower
        ];

        systemd.user.services.hypower = {
          Unit = {
            Description = "Hyprland power profile switcher";
            After = [ config.wayland.systemd.target ];
            PartOf = [ config.wayland.systemd.target ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${hypower}/bin/hypower";
            Restart = "on-failure";
            RestartSec = "3s";
          };
          Install.WantedBy = [ config.wayland.systemd.target ];
        };
      };
    };
}
