let
  mkWidget =
    overrides:
    {
      id = "SystemMonitor";
      compactMode = false;
      iconColor = "secondary";
      textColor = "secondary";
      useMonospaceFont = true;
      usePadding = true;

      showCpuCores = false;
      showCpuFreq = false;
      showCpuTemp = false;
      showCpuUsage = false;
      showLoadAverage = false;

      showDiskAvailable = false;
      showDiskUsage = false;
      showDiskUsageAsPercent = false;

      showGpuTemp = false;

      diskPath = "/";
      showMemoryAsPercent = false;
      showMemoryUsage = false;
      showSwapUsage = false;

      showNetworkStats = false;
    }
    // overrides;

in
rec {
  cpu = {
    temp = mkWidget {
      showCpuTemp = true;
    };
    freq = mkWidget {
      showCpuFreq = true;
    };
    usage = mkWidget {
      showCpuUsage = true;
    };
  };
  memory = {
    usage = mkWidget {
      showMemoryUsage = true;
    };
  };
  network = mkWidget {
    showNetworkStats = true;
  };
  system = [
    memory.usage
    cpu.usage
    cpu.freq
    cpu.temp
  ];
}
