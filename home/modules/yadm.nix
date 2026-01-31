{ pkgs, lib, config, ... }:

let
  cfg = config.programs.yadm;
in
{
  options.programs.yadm = {
    enable = lib.mkEnableOption "YADM";

    package = lib.mkPackageOption pkgs "yadm" {
      nullable = true;
    };

    repository = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Git repository URL for dotfiles";
    };

    autoClone = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically clone repository on activation";
    };

    autoBootstrap = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Run bootstrap script after cloning";
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = lib.mkIf (cfg.package != null) [
      cfg.package
    ];

    home.activation.yadmClone =
      lib.mkIf (cfg.autoClone && cfg.repository != "")
        (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ ! -d "$HOME/.local/share/yadm/repo.git" ]; then
            $DRY_RUN_CMD ${pkgs.yadm}/bin/yadm clone \
              ${lib.optionalString (!cfg.autoBootstrap) "--no-bootstrap"} "${cfg.repository}"
            $DRY_RUN_CMD ${pkgs.yadm} restore --staged ${config.home.homeDirectory}
            $DRY_RUN_CMD ${pkgs.yadm} checkout -- ${config.home.homeDirectory}
          else
            echo "yadm already initialized, skipping clone"
          fi
        '');
  };
}
