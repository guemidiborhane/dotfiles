{ cfg, lib, pkgs, meta, helpers, ... }:
let
  host = meta.host;
  defaults = cfg.defaults;
  features = defaults.features // (host.features or {});
in
{
  imports = [
    ../modules/hyprland.nix
  ];

  services = {
    printing = helpers.enabled;
    udisks2 = helpers.enabled;
    gvfs = helpers.enabled;
    pipewire = import ../modules/services/pipewire.nix;
  };

  hardware.bluetooth.enable = features.bluetooth;
  services.blueman.enable = features.bluetooth;
  services.fprintd.enable = features.fingerprint;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  fonts.packages = with pkgs; [
     cantarell-fonts
     nerd-fonts.monaspace
     nerd-fonts.jetbrains-mono
  ];
}
