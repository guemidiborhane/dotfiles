{ pkgs, ... }: {
  services.gnome-keyring = {
    enable = true;
    # package = pkgs.unstable.gnome-keyring;
    components = [
      "pkcs11"
      "secrets"
    ];
  };
  home.packages = with pkgs; [ gcr ];
}
