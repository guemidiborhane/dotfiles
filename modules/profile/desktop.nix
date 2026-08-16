{ self, ... }:
{
  flake = {
    unfreePackages = [
      "corefonts"
      "vista-fonts" # Calibri
    ];

    modules = {
      nixos.profiles-desktop =
        {
          inputs,
          lib,
          pkgs,
          ...
        }:
        {
          imports = with self.modules.nixos; [
            solaar
            pipewire
            desktop-hyprland
            thunar
            inputs.vicinae.nixosModules.default
          ];

          services = {
            printing.enable = true;
            udisks2.enable = true;
            gvfs.enable = true;
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

          fonts = {
            enableDefaultPackages = true;
            fontDir.enable = true;
            packages = with pkgs; [
              nerd-fonts.monaspace
              nerd-fonts.jetbrains-mono
              cantarell-fonts
              lexend
              nerd-fonts.symbols-only
              noto-fonts-color-emoji
              noto-fonts
              noto-fonts-cjk-sans
            ];

            fontconfig = {
              # issue: https://github.com/NixOS/nixpkgs/issues/541553
              # pull: https://github.com/NixOS/nixpkgs/pull/551126
              defaultFonts = {
                monospace = [ ];
                sansSerif = [ ];
                serif = [ ];
                emoji = [ ];
              };

              aliases =
                let
                  defaultFonts = {
                    monospace = [
                      "JetBrainsMono Nerd Font"
                      "Symbols Nerd Font Mono"
                      "Noto Sans Mono"
                    ];
                    sans-serif = [
                      "Cantarell"
                      "Noto Sans"
                    ];
                    serif = [
                      "Cantarell"
                      "Noto Sans"
                    ];
                    emoji = [ "Noto Color Emoji" ];
                  };
                in
                builtins.mapAttrs (name: value: {
                  binding = "strong";
                  prefer = value;
                }) defaultFonts;
            };
          };
        };

      homeManager.profiles-desktop =
        { pkgs, ... }:
        {
          imports = with self.modules.homeManager; [
            pkgs-desktop
            desktop-hyprland
            solaar

            gnome-keyring
            gnome-polkit
            udiskie

            zen-browser
            kitty
            foot
            vicinae
            mpv
            discord
          ];
        };
    };
  };
}
