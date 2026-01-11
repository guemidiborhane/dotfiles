{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    kitty
    git
    git-lfs
    fastfetch
    ripgrep
    fd
    gcc
    rustup
    lazygit
    libnotify
    bc
    btop
    bandwhich
    lm_sensors
    jq
    config.boot.kernelPackages.cpupower
  ];

  fonts.packages = with pkgs; [
     cantarell-fonts
     nerd-fonts.monaspace
     nerd-fonts.jetbrains-mono
  ];
}
