{
  pkgs,
  helpers,
  ...
}: {
  services = {
    printing = helpers.enabled;
    udisks2 = helpers.enabled;
    fstrim = helpers.enabled;
    fwupd = helpers.enabled;
    tlp = import ./tlp.nix;
    pipewire = import ./pipewire.nix;
    openssh = import ./openssh.nix;
  };
}
