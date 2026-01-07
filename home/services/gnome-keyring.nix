{ pkgs, ... }: {
  enable = true;
  # package = pkgs.unstable.gnome-keyring;
  components = [
    "pkcs11"
    "secrets"
  ];
}
