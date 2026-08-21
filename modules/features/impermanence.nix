{ lib, ... }:
let
  inherit (lib) mkOption types;

  persistentPath = "/persistent";

  persistEntries = {
    directories = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Directories to persist across boots.";
    };

    files = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Files to persist across boots.";
    };
  };

  optionsModule = { _, ... }: { options.dex.persist = persistEntries; };
in
{

  config = {
    flake-file.inputs.impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };

    flake.modules = {
      nixos.dex-persist = optionsModule;
      homeManager.dex-persist = optionsModule;

      nixos.impermanence =
        {
          inputs,
          host,
          hardware,
          config,
          ...
        }:
        let
          cfg = config.dex.persist;
        in
        {
          assertions = [
            {
              assertion = hardware.isMicroVM;
              message = "dex.persist is set on ${host.name} (a bare metal host), persistence isn't supported there.";
            }
          ];

          microvm.shares = [
            {
              proto = "virtiofs";
              tag = "persistent";
              source = "/var/lib/microvms/${host.name}/${persistentPath}";
              mountPoint = persistentPath;
            }
          ];

          imports = [ inputs.impermanence.nixosModules.impermanence ];
          fileSystems."${persistentPath}".neededForBoot = lib.mkForce true;
          environment.persistence."${persistentPath}" = {
            hideMounts = true;
            directories = [
              "/var/log"
              "/var/lib/nixos"
              "/var/lib/systemd/coredump"
            ]
            ++ (cfg.directories or [ ]);

            files = [ "/etc/machine-id" ] ++ (cfg.files or [ ]);
          };
        };

      homeManager.impermanence =
        {
          user,
          hardware,
          config,
          ...
        }:
        let
          cfg = config.dex.persist;
        in
        {
          home.persistence."${persistentPath}/users/${user.username}" = {
            directories = map (directory: {
              inherit directory;
              mode = "0700";
            }) ((cfg.directories or [ ]) ++ [ ".ssh" ]);

            files = cfg.files or [ ];
          };
        };
    };
  };
}
