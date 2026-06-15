{ _, ... }:
{
  flake.modules.nixos.pipewire =
    { _, ... }:
    {
      security.rtkit.enable = true;
      services.pulseaudio.enable = false;

      services.pipewire = {
        enable = true;

        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
        jack.enable = true;

        wireplumber.extraConfig."10-audio-priority" = {
          "monitor.alsa.rules" = [
            {
              matches = [ { "node.name" = "alsa_output.pci-0000_c4_00.6.HiFi__Speaker__sink"; } ];
              actions."update-props"."priority.session" = 1000;
            }
            {
              matches = [ { "node.name" = "alsa_output.pci-0000_c4_00.1.HiFi__HDMI2__sink"; } ];
              actions."update-props"."priority.session" = 1500;
            }
          ];
          "monitor.bluez.rules" = [
            {
              matches = [ { "node.name" = "~bluez_output.*"; } ];
              actions."update-props"."priority.session" = 2000;
            }
          ];
        };
      };
    };
}
