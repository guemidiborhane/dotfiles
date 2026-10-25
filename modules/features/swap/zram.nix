_: {
  flake.modules.nixos.zram-swap = _: {
    zramSwap = {
      enable = true;
      priority = 100;
      algorithm = "zstd";
      memoryPercent = 30;
    };
  };
}
