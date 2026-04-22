{ self, ... }:
{
  flake-file.inputs.hyprland.url = "github:hyprwm/Hyprland";
  flake = {
    substituters.hyprland = [
      {
        url = "https://hyprland.cachix.org";
        key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
      }
    ];

    modules.nixos.desktop-hyprland =
      { inputs, pkgs, ... }:
      {
        imports = [ inputs.hyprland.nixosModules.default ];
        programs.hyprland = {
          enable = true;
          package = pkgs.hyprland;
        };

        environment.systemPackages = with pkgs; [
          wl-clipboard
        ];
      };

    modules.homeManager.desktop-hyprland =
      { inputs, pkgs, ... }:
      {
        imports = with self.modules.homeManager; [
          inputs.hyprland.homeManagerModules.default

          desktop-common
          services-hyprpower
          programs-noctalia
        ];

        home.packages = with pkgs; [ hyprpicker ];
        wayland.systemd.target = "hypr-session.target";
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
          package = pkgs.hyprland;
        };

        services = {
          hypridle.enable = true;
        };
      };
  };
}
