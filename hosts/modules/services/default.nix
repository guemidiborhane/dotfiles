{ h, ... }:
{
  services = {
    fstrim = h.enabled;
    fwupd = h.enabled;
    openssh = import ./openssh.nix;
  };
}
