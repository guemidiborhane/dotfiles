{ self, ... }:
{
  flake.modules.nixos.entrypoint = ctx: {
    imports =
      with self.modules.nixos;
      [
        nix-config
        disko-config
        host-hardware
        kernel
        locales
        common-host-configs
        features
        users
        networking
        base-devel
        pkgs
        host-profile
        default-programs
      ]
      ++ map (module: self.modules.nixos."${module}") ctx.host.modules;
  };

  flake.modules.homeManager.entrypoint = ctx: {
    imports =
      with self.modules.homeManager;
      [
        nur
        home-config
        pkgs
        host-profile
      ]
      ++
        map (module: self.modules.homeManager."${module}")
          ctx.user.modules or self.dex.defaults.users.modules or [ ];
  };
}
