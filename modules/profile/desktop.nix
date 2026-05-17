{ self, ... }:
{
  flake.modules.nixos.profiles-desktop =
    {
      inputs,
      features,
      lib,
      pkgs,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        inputs-solaar
        services-pipewire
        desktop-hyprland
        programs-thunar
        inputs.vicinae.nixosModules.default
      ];

      services = {
        printing.enable = true;
        udisks2.enable = true;
        gvfs.enable = true;
        solaar.enable = true;
      };

      hardware.graphics.enable = true;

      powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

      programs = {
        localsend.enable = true;
        gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
      };

      environment.systemPackages = with pkgs; [
        bitwarden-desktop
      ];

      fonts.packages = with pkgs; [
        cantarell-fonts
        nerd-fonts.monaspace
        nerd-fonts.jetbrains-mono
        corefonts
        vista-fonts
      ];
    };

  flake.modules.homeManager.profiles-desktop =
    { pkgs, inputs, ... }:
    {
      imports = with self.modules.homeManager; [
        pkgs-desktop
        desktop-hyprland

        services-gnome-keyring
        services-gnome-polkit
        services-udiskie

        programs-zen-browser
        programs-ghostty
        programs-foot
        programs-vicinae
        programs-mpv

        features-gaming
      ];

      programs.wezterm.enable = true;
    };
}
