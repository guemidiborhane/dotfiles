{ ... }:
{
  imports = [
    ./openssh.nix
    ./qbittorrent.nix
  ];

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
  };
}
