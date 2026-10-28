{ self, lib, ... }:
let
  inherit (self.helpers) utils;
  inherit (self) tomlConfigs;

  getUser =
    username:
    tomlConfigs.users.${username} or (throw "Unknown user '${username}' referenced in users.toml");

  getHost' =
    name: host:
    let
      inherit (tomlConfigs) defaults;

      cascade =
        key:
        utils.deepMerge [
          (defaults.${key} or { })
          (defaults.${key}.${host.type} or { })
          (host.${key} or { })
        ];

      config = utils.deepMerge [
        defaults.host
        host
        {
          inherit name;
          hostname = host.hostname or name;
        }
      ];

      hardwareConfig = cascade "hardware";
      hardwareHelpers = {
        isLaptop = host.type == "laptop";
        isDesktop = host.type == "desktop";
        isHeadless = host.type == "headless";
        isMicroVM = host.type == "vm";
        isBareMetal = host.type != "vm";

        hasAMD = hardwareConfig.cpu == "amd";
        hasIntel = hardwareConfig.cpu == "intel";
        hasNvidia = hardwareConfig.gpu == "nvidia";
        hasAMDGPU = hardwareConfig.gpu == "amd";
      };

      users = builtins.mapAttrs (
        username: overrides:
        utils.deepMerge [
          defaults.users
          (getUser username)
          overrides
          { inherit username; }
        ]
      ) (lib.filterAttrs (username: user: user.enable or true) config.users);

      usersHelpers = {
        forEach = fn: builtins.mapAttrs fn users;
      };

      ctx = {
        inherit name config;

        hardware = hardwareConfig // hardwareHelpers;
        features = cascade "features";
        users = users // usersHelpers;
      };
    in
    self.dex.validate ctx;
in
{
  options.flake.unfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Package names allowed through allowUnfreePredicate, merged across all modules.";
  };

  options.flake.dex = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        {
          # Keep `flake.dex` an open attrset so modules can freely assign keys
          # like `helpers`, `secrets`, `metadata`, `hosts`, `validate`, etc.,
          # while still declaring list-merging sub-options such as `rules`.
          freeformType = lib.types.attrsOf lib.types.raw;

          options.rules = lib.mkOption {
            type = lib.types.listOf (lib.types.functionTo (lib.types.listOf lib.types.str));
            default = [ ];
            description = ''
              Conditional cross-field validation rules over a host's cascaded
              context.

              Each rule is a function `ctx -> [ errorString ]` where `ctx` is the
              per-host context `{ name, config, hardware, features, users }`. A
              rule returns the list of violation messages it found (empty when
              satisfied).

              Rules are colocated with the module they constrain and aggregated
              by `flake.dex.validate`, which throws if any rule reports an error.
              Use these for a field consumed in a single module; fields consumed
              in multiple places, and closed-domain/referential schema checks,
              belong in `modules/config/config.nix` instead.
            '';
          };
        }
      ];
    };
    default = { };
    description = "The all-knowing oracle. Reads some TOML files, dramatically transforms them into structured Nix, and pretends it was always this organised.";
  };

  config = {
    flake.dex = {
      inherit (tomlConfigs) defaults;

      getHost =
        name:
        getHost' name (
          tomlConfigs.hosts.${name} or (throw "Unknow host '${name}' referenced in hosts.toml")
        );

      metadata = {
        repository = "https://github.com/guemidiborhane/nixos-config";
        stateVersion = "25.11";
        flake = "/etc/nixos";
      };

      hosts = builtins.mapAttrs getHost' (
        lib.filterAttrs (_: host: host.type or null != "vm") tomlConfigs.hosts
      );

      defaultSystem = tomlConfigs.defaults.host.system;

      hostModules = [ self.modules.nixos.entrypoint ];
      homeModules = [ self.modules.homeManager.entrypoint ];
    };
  };
}
