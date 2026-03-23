{ inputs, self, ... }:
{

  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.nixosModules.users-home-manager =
    ctx@{
      inputs,
      pkgs,
      h,
      ...
    }:
    {
      imports = [
        self.nixosModules.inputs-nur
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = true;
        backupCommand = "trash";

        extraSpecialArgs = h.mkHomeContext ctx pkgs;

        users = h.forEachUser (
          username: user: {
            _module.args = { inherit user; };
            imports = ctx.homeModules;
          }
        );
      };
    };

}
