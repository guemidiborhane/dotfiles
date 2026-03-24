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
        programs.hyprland.enable = true;

        environment.systemPackages = with pkgs; [
          wl-clipboard
        ];
      };

    homeModules.desktop-hyprland =
      { inputs, pkgs, ... }:
      {
        imports = [
          inputs.hyprland.homeManagerModules.default
          inputs.self.homeModules.desktop-common
          inputs.self.homeModules.services-hyprpower
        ];

        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = false;
        };

        services = {
          hypridle.enable = true;
        };
      };
  };
}
