{ pkgs, helpers, ... }:
{
  services = {
    fstrim = helpers.enabled;
    fwupd = helpers.enabled;
    openssh = import ./openssh.nix;
  };
}
