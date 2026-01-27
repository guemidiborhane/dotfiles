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
    fans = [{
      type = "tpacpi";
      query = "/proc/acpi/ibm/fan";
    }];

    # Fan speed levels [LEVEL, LOW, HIGH]
    levels = [
      [ 0 0 60 ]
      [ 1 58 63 ]
      [ 2 61 66 ]
      [ 3 64 69 ]
      [ 4 67 72 ]
      [ 5 70 75 ]
      [ 6 73 78 ]
      [ 7 76 81 ]
      [ "level full-speed" 79 32767 ]
    ];
  };
}
