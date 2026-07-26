{ self, lib, ... }:
let
  inherit (self.helpers) utils;
  inherit (self) tomlConfigs;

  getUser =
    username:
    tomlConfigs.users.${username} or (throw "Unknown user '${username}' referenced in host.users");

  getHost =
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

        hasAMD = hardwareConfig.cpu == "amd";
        hasIntel = hardwareConfig.cpu == "intel";
        hasNvidia = hardwareConfig.gpu == "nvidia";
        hasAMDGPU = hardwareConfig.gpu == "amd";
      };

      users = builtins.mapAttrs (
        username: overrides: getUser username // overrides // { inherit username; }
      ) (lib.filterAttrs (username: overrides: overrides.enable or true) config.users);

      usersHelpers = {
        forEach = fn: builtins.mapAttrs fn users;
      };
    in
    {
      inherit config;

      hardware = hardwareConfig // hardwareHelpers;
      features = cascade "features";
      users = users // usersHelpers;
    };
in
{
  options.flake.unfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Package names allowed through allowUnfreePredicate, merged across all modules.";
  };

  options.flake.dex = lib.mkOption {
    type = lib.types.attrsOf lib.types.raw;
    default = { };
    description = "The all-knowing oracle. Reads some TOML files, dramatically transforms them into structured Nix, and pretends it was always this organised.";
  };

  config = {
    flake.dex = {
      inherit (tomlConfigs) defaults;

      metadata = {
        repository = "https://github.com/guemidiborhane/nixos-config";
        stateVersion = "25.11";
        flake = "/etc/nixos";
      };

      hosts = builtins.mapAttrs getHost tomlConfigs.hosts;

      defaultSystem = tomlConfigs.defaults.host.system;

      hostModules = [ self.modules.nixos.entrypoint ];
      homeModules = [ self.modules.homeManager.entrypoint ];
    };

    flake.modules.homeManager.dex =
      { pkgs, metadata, ... }:
      let
        dexPkg = pkgs.writeScriptBin "dex" /* sh */ ''
          #!/usr/bin/env sh
          exec ${pkgs.just}/bin/just \
            --justfile "${metadata.flake}/Justfile" \
            --working-directory "${metadata.flake}" \
            "$@"
        '';
        yayPkg = pkgs.writeScriptBin "yay" /* sh */ ''
          #!/usr/bin/env sh
          setsid ${pkgs.kitty}/bin/kitty sh -c '
            "${dexPkg}/bin/dex" yay "$@"
            printf "\n[Press Enter to exit]"
            read -r _
          ' _ "$@" </dev/null >/dev/null 2>&1 &
          disown
        '';
      in
      {
        programs.fish = {
          shellAbbrs = {
            ds = "dex switch";
            db = "dex boot";
            dt = "dex test";
          };

          completions = {
            dex = "complete -c dex --wraps just";
            yay = "complete -c yay --wraps dex";
          };
        };

        home.packages = [
          dexPkg
          yayPkg
        ];
      };
  };
}
