{ h, ... }:
{
  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    openssh = import ./openssh.nix;
  };
}
