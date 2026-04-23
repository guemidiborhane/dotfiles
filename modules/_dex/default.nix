{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
  inherit (inputs.self) dex;

  inherit (dex) metadata defaultSystem;
  inherit (dex) hostModules homeModules;

  mkPkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = builtins.attrValues inputs.self.overlays;

      config = {
        allowBroken = false;
        allowUnfree = true;
      };
    };

  mkContext = hostOrContext: {
    inherit metadata;
    inherit (hostOrContext) features power users;
    inherit (hostOrContext) hardware networking;
    secrets = import ./secrets.nix;
    host =
      if (hostOrContext ? host) then
        hostOrContext.host # When called from mkHomeContext
      else
        hostOrContext.self; # When called from mkArgs
  };

  mkArgs =
    host:
    let
      system = host.config.system or defaultSystem;
      pkgs = mkPkgs system;
      ctx = mkContext host;
      helpers = import ./helpers { inherit pkgs ctx; };
      mkHomeContext =
        hostCtx: pkgs:
        (mkContext hostCtx)
        // {
          inherit inputs pkgs;
          h = helpers;
        };
      specialArgs = ctx // {
        inherit inputs;
        h = helpers // {
          inherit mkHomeContext;
        };
      };
    in
    {
      inherit system pkgs specialArgs;
    };

  mkHost =
    host:
    let
      config = mkArgs host;
      inherit (config) specialArgs;
    in
    lib.nixosSystem {
      inherit (config) pkgs system;
      specialArgs = specialArgs // {
        inherit homeModules;
      };
      modules = hostModules;
    };

  mkHome =
    { user, host }:
    let
      config = mkArgs host;
      inherit (config) specialArgs;
    in
    lib.homeManagerConfiguration {
      inherit (config) pkgs;
      extraSpecialArgs = specialArgs // {
        inherit user;
      };
      modules = homeModules;
    };

  mkHostConfigs =
    host:
    let
      inherit (host.self) hostname;
    in
    {
      nixos = {
        name = hostname;
        value = mkHost host;
      };

      homes = lib.mapAttrsToList (username: user: {
        name = "${username}@${hostname}";
        value = mkHome { inherit host user; };
      }) host.users;
    };

  allConfigs = map mkHostConfigs dex.hosts;
in
{
  nixosConfigurations = lib.listToAttrs (map (c: c.nixos) allConfigs);
  homeConfigurations = lib.listToAttrs (lib.flatten (map (c: c.homes) allConfigs));
}
