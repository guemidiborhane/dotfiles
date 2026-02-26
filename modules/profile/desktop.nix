{ _, ... }:
{
  flake.nixosModules.profiles-desktop =
    {
      inputs,
      features,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.nixosModules.inputs-solaar
        inputs.self.nixosModules.services-pipewire
        inputs.self.nixosModules.desktop-hyprland
        inputs.self.nixosModules.programs-thunar
      ];

      services = {
        printing.enable = true;
        udisks2.enable = true;
        gvfs.enable = true;
        solaar.enable = true;
        fprintd.enable = features.fingerprint;
      };

      hardware.graphics.enable = true;

      hardware.bluetooth.enable = features.bluetooth;
      services.blueman.enable = features.bluetooth;

      powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

      programs = {
        localsend.enable = true;
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

  flake.homeModules.profiles-desktop =
    { pkgs, inputs, ... }:
    {
      imports = [
        inputs.self.homeModules.pkgs-desktop
        inputs.self.homeModules.desktop-hyprland

        inputs.self.homeModules.services-gnome-keyring
        inputs.self.homeModules.services-gnome-polkit
        inputs.self.homeModules.services-udiskie

        inputs.self.homeModules.programs-zen-browser
        inputs.self.homeModules.programs-ghostty
        inputs.self.homeModules.programs-foot
        inputs.self.homeModules.programs-vicinae
      ];

      programs = {
        wezterm.enable = true;
        mpv.enable = true;
      };
    };
}
