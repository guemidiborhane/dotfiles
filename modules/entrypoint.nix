{ self, ... }:
{
  flake.modules.nixos.entrypoint =
    { inputs, ... }:
    {
      imports = with self.modules.nixos; [
        nix-config
        disko-config
        kernel
        locales
        common-host-configs
        features
        users
        hardware-host
        networking
        virtualisation
        base-devel
        pkgs-defaults
        services-openssh
        services-fstrim
        services-fwupd
        host-profile
        default-programs
      ];
    };

  flake.modules.homeManager.entrypoint =
    { user, ... }:
    {
      imports = with self.modules.homeManager; [
        inputs-nur
        home-config
        pkgs
        programs-git
        programs-yadm
        programs-yazi
        shell
        host-profile
      ];
    };
}
