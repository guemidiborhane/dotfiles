{ self, ... }:
{
  flake.modules.nixos.entrypoint = ctx: {
    imports = map (module: self.modules.nixos."${module}") ctx.host.modules;
  };

  flake.modules.homeManager.entrypoint = ctx: {
    imports =
      map (module: self.modules.homeManager."${module}")
        ctx.user.modules or self.dex.defaults.users.modules or [ ];
  };
}
