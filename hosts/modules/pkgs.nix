{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    curl
    kitty
    git
    ripgrep
    fd
    gcc
    rustup
    libnotify
    bc
    btop
    bandwhich
    lm_sensors
    jq
    config.boot.kernelPackages.cpupower
    trashy
    just
  ];

  fonts.packages = with pkgs; [
     cantarell-fonts
     nerd-fonts.monaspace
     nerd-fonts.jetbrains-mono
  ];
}
