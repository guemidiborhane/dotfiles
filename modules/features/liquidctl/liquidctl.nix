_: {
  flake.modules.nixos.liquidctl =
    {
      lib,
      hardware,
      features,
      pkgs,
      ...
    }:
    let
      # match (device filter) and sensor (yoda source) come from hosts.toml
      # (features.liquidctl); the [temp, speed] points from hardware.fan.speeds.
      # type/interval stay module defaults until a second host needs them tunable.
      inherit (features.liquidctl) match sensor;
      interval = 2;
      curve = {
        type = "fan";
        inherit sensor;
        points = hardware.fan.speeds;
      };

      mkPoints = lib.concatMapStringsSep "," (
        p: "(${toString (builtins.elemAt p 0)},${toString (builtins.elemAt p 1)})"
      );
      clause = "${curve.type} with ${mkPoints curve.points} on ${curve.sensor}";
    in
    {
      services.udev.packages = [ pkgs.liquidctl ];

      systemd.services.liquidctl = {
        description = "liquidctl yoda dynamic pump/fan curve daemon";
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStartPre = "${pkgs.liquidctl}/bin/liquidctl initialize all";
          ExecStart = "${pkgs.liquidctl-yoda}/bin/yoda -v --match '${match}' --interval ${toString interval} control ${clause}";
          Restart = "on-failure";
          RestartSec = 5;
          User = "root";
        };
      };
    };
}
