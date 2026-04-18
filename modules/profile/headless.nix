{ _, ... }:
{
  flake.modules.nixos.profiles-headless =
    { lib, ... }:
    {
      services.xserver.enable = lib.mkForce false;
      programs.hyprland.enable = lib.mkForce false;

      sound.enable = lib.mkForce false;
      services.pulseaudio.enable = lib.mkForce false;
      services.pipewire.enable = lib.mkForce false;

      hardware.bluetooth.enable = lib.mkForce false;
      services.blueman.enable = lib.mkForce false;
    };

  flake.modules.homeManager.profiles-headless = { _, ... }: { };
}
