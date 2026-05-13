{ _, ... }:
{
  flake.modules.nixos.hardware-thinkfan =
    { _, ... }:
    {
      services.thinkfan = {
        enable = true;

        # Sensors configuration
        sensors = [
          {
            type = "tpacpi";
            query = "/proc/acpi/ibm/thermal";
            indices = [ 1 2 3 4 ];
          }
          {
            type = "hwmon";
            query = "/sys/class/hwmon";
            name = "amdgpu";
            indices = [ 1 ];
          }
          {
            type = "hwmon";
            query = "/sys/class/hwmon";
            name = "k10temp";
            indices = [ 1 ];
          }
          {
            type = "hwmon";
            query = "/sys/class/hwmon";
            name = "thinkpad";
            indices = [ 1 3 6 7 ];
            max_errors = 10;
          }
          {
            type = "hwmon";
            query = "/sys/class/hwmon";
            name = "nvme";
            indices = [ 1 ];
          }
          {
            type = "hwmon";
            query = "/sys/class/hwmon";
            name = "acpitz";
            indices = [ 1 ];
          }
        ];

        # Fan configuration
        fans = [
          {
            type = "tpacpi";
            query = "/proc/acpi/ibm/fan";
          }
        ];

        # Fan speed levels [LEVEL, LOW, HIGH]
        levels = [
          [ 0                0  55 ]
          [ 1               50  62 ]
          [ 2               57  68 ]
          [ 3               63  74 ]
          [ 4               69  79 ]
          [ 5               74  84 ]
          [ 6               79  89 ]
          [ "level full-speed" 85 32767 ]
        ];
      };
    };
}
