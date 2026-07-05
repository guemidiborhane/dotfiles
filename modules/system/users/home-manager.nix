{ self, ... }:
{
  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.users-home-manager =
    ctx@{
      inputs,
      pkgs,
      h,
      users,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.modules.nixos.nur
      ];

      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = true;
        backupCommand = ctx.lib.getExe pkgs.trashy;

        extraSpecialArgs = h.mkHomeContext ctx pkgs;

        users = users.forEach (
          username: user: {
            _module.args = { inherit user; };
            imports = ctx.homeModules;
          }
        );
      };
    };

}
