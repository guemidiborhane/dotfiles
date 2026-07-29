{ self, lib, ... }:
let
  inherit (self) inputs dex;

  inherit (dex) defaultSystem;
  inherit (dex) hostModules homeModules;

  mkPkgs =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = builtins.attrValues self.overlays;

      config = {
        allowBroken = false;
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) self.unfreePackages;
        permittedInsecurePackages = [ ];
      };
    };

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
