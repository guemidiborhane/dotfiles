{ self, ... }:
{
  flake.homeModules.entrypoint-home =
    { user, ... }:
    {
      imports = with self.homeModules; [
        inputs-nur
        home-config
        default-pkgs
        programs-git
        programs-yadm
        programs-yazi
        shell
        host-profile
      ];

      programs.home-manager.enable = true;
    };
}
