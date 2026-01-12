{
  pkgs,
  enabled,
  ...
}: {
  services = {
    printing = enabled;
    udisks2 = enabled;
    fstrim = enabled;
    fwupd = enabled;
    tlp = import ./tlp.nix;
    pipewire = import ./pipewire.nix;
    openssh = import ./openssh.nix;
  };
}
