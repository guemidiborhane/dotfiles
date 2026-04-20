{ lib, ... }:
{
  flake.modules.nixos.programs-nh = {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "monthly";
        extraArgs = "--keep-since 7d --keep 3";
      };
      flake = "/etc/nixos";
    };
    systemd.timers.nh-clean = {
      timerConfig = {
        Persistent = lib.mkForce false; # don't catch up on missed runs
      };
    };
    systemd.services.nh-clean = {
      serviceConfig = {
        IOSchedulingClass = "idle";
        IOSchedulingPriority = 7;
        CPUSchedulingPolicy = "idle";
        Nice = 19;
      };
    };
  };
}
