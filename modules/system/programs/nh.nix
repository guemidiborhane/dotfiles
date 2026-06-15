{ lib, ... }:
{
  flake.modules.nixos.nh =
    { metadata, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          dates = "monthly";
          extraArgs = "--keep-since 7d --keep 3";
        };
        inherit (metadata) flake;
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

      programs.fish.shellAbbrs = {
        ss = "nh search";
      };
    };
}
