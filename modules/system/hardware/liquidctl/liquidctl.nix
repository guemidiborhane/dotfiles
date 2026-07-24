{ _, ... }:
{
  flake.modules.nixos.hardware-liquidctl =
    { lib, hardware, config, pkgs, ... }:
    let
      cfg = config.services.liquidctl;
      yodaPkg = pkgs.callPackage ./_yoda.nix { };

      mkPoints =
        points:
        lib.concatMapStringsSep "," (
          p:
          let
            temp = builtins.elemAt p 0;
            speed = builtins.elemAt p 1;
          in
          "(${toString temp},${toString speed})"
        ) points;

      mkClause = c: "${c.type} with ${mkPoints c.points} on ${c.sensor}";
    in
    {
      options.services.liquidctl = {
        enable = lib.mkEnableOption "liquidctl yoda dynamic fan/pump curve daemon";

        match = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "liquidctl --match device filter substring";
        };

        interval = lib.mkOption {
          type = lib.types.int;
          default = 2;
        };

        curves = lib.mkOption {
          type = lib.types.listOf (
            lib.types.submodule {
              options = {
                type = lib.mkOption {
                  type = lib.types.enum [
                    "pump"
                    "fan"
                  ];
                  description = "Which channel this curve controls";
                };

                sensor = lib.mkOption {
                  type = lib.types.str;
                  description = "yoda sensor source, e.g. 'k10temp.tctl' or 'istats.cpu'";
                };

                points = lib.mkOption {
                  type = lib.types.listOf (lib.types.addCheck (lib.types.listOf lib.types.int) (p: builtins.length p == 2));
                  description = "List of [temp, speed] pairs";
                  example = [
                    [ 20 50 ]
                    [ 50 100 ]
                  ];
                };
              };
            }
          );
          default = [ ];
          example = [
            {
              type = "pump";
              sensor = "istats.cpu";
              points = [
                [ 20 50 ]
                [ 50 100 ]
              ];
            }
            {
              type = "fan";
              sensor = "_internal.liquid";
              points = [
                [ 20 25 ]
                [ 34 100 ]
              ];
            }
          ];
        };
      };

      config = lib.mkIf cfg.enable {
        services.udev.packages = [ pkgs.liquidctl ];

        systemd.services.liquidctl = {
          description = "liquidctl yoda dynamic pump/fan curve daemon";
          after = [ "multi-user.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStartPre = "${pkgs.liquidctl}/bin/liquidctl initialize all";
            ExecStart =
              let
                matchArg = lib.optionalString (cfg.match != null) "--match '${cfg.match}'";
                clauses = lib.concatMapStringsSep " and " mkClause cfg.curves;
              in
              "${yodaPkg}/bin/yoda -v ${matchArg} --interval ${toString cfg.interval} control ${clauses}";
            Restart = "on-failure";
            RestartSec = 5;
            User = "root";
          };
        };
      };
    };
}
