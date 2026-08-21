{ self, lib, ... }:
let
  inherit (self) inputs dex;

  inherit (dex) defaultSystem;
  inherit (dex) hostModules homeModules;

  mkNixPkgsConfig =
    system: overrides:
    {
      inherit system;

      config = {
        allowBroken = false;
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) self.unfreePackages;
        permittedInsecurePackages = [ ];
      };
    }
    // overrides;

  mkPkgs =
    system:
    let
      overlays = builtins.attrValues self.overlays;
      config = mkNixPkgsConfig system { inherit overlays; };
    in
    import inputs.nixpkgs config;

  mkContext = hostOrContext: {
    inherit (dex) metadata secrets;
    inherit (hostOrContext) features hardware users;

    host =
      if (hostOrContext ? host) then
        hostOrContext.host # When called from mkHomeContext
      else
        hostOrContext.config; # When called from mkArgs
  };

  mkArgs =
    host:
    let
      inherit (self) helpers;

      system = host.config.system or defaultSystem;
      pkgs = mkPkgs system;
      ctx = mkContext host;

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
in
{
  flake.dex.helpers = {
    inherit mkNixPkgsConfig;

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
  };
}
