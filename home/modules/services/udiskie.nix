{ ... }:
{
  services.udiskie = {
    enable = true;
    # package = pkgs.unstable.udiskie;
    automount = true;
    notify = true;
    tray = "always";
  };
}
