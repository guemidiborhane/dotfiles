{ self, ... }:
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
        self.nixosModules.inputs-solaar
        self.nixosModules.services-pipewire
        self.nixosModules.desktop-hyprland
        self.nixosModules.programs-thunar
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
        self.homeModules.pkgs-desktop
        self.homeModules.desktop-hyprland

        self.homeModules.services-gnome-keyring
        self.homeModules.services-gnome-polkit
        self.homeModules.services-udiskie

        self.homeModules.programs-noctalia
        self.homeModules.programs-zen-browser
        self.homeModules.programs-ghostty
        self.homeModules.programs-foot
        self.homeModules.programs-vicinae
        self.homeModules.programs-mpv
      ];

      programs.wezterm.enable = true;
    };
}
