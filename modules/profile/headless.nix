{ _, ... }:
{
  flake.modules.nixos.headless-profile =
    { lib, ... }:
    {
      services = {
        xserver.enable = lib.mkForce false;
        pulseaudio.enable = lib.mkForce false;
        pipewire.enable = lib.mkForce false;
        blueman.enable = lib.mkForce false;
      };

      programs.hyprland.enable = lib.mkForce false;
      hardware.bluetooth.enable = lib.mkForce false;
    };

  flake.modules.homeManager.headless-profile = { _, ... }: { };
}
