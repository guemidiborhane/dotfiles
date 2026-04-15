{ _, ... }:
{
  flake-file.inputs.hyprland.url = "github:hyprwm/Hyprland";
  flake = {
    substituters.hyprland = [
      {
        url = "https://hyprland.cachix.org";
        key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
      }
    ];

    nixosModules.desktop-hyprland =
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

    homeModules.desktop-hyprland =
      { inputs, pkgs, ... }:
      {
        imports = with inputs; [
          hyprland.homeManagerModules.default

          self.homeModules.desktop-common
          self.homeModules.services-hyprpower
          self.homeModules.programs-noctalia
        ];

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
