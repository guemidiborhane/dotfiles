{ _, ... }:
let
  mkConfig = inputs: pkgs: {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
in
{
  flake-file.inputs.hyprland.url = "github:hyprwm/Hyprland";

  flake.nixosModules.desktop-hyprland =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.hyprland.nixosModules.default ];
      programs.hyprland = mkConfig inputs pkgs;

      environment.systemPackages = with pkgs; [
        wl-clipboard
      ];
    };

  flake.homeModules.desktop-hyprland =
    { inputs, pkgs, ... }:
    {
      imports = [ inputs.self.homeModules.desktop-common ];

      wayland.windowManager.hyprland = (mkConfig inputs pkgs) // {
        systemd.enable = false;
      };

      services.hypridle.enable = true;
      services.swaync.enable = true;
      programs.wlogout.enable = true;
    };
}
