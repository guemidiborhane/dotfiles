{ ... }:
{
  imports = [
    ./openssh.nix
  ];

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
  };
}
