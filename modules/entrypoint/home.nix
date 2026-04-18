{ self, ... }:
{
  flake.modules.homeManager.entrypoint =
    { user, ... }:
    {
      imports = with self.modules.homeManager; [
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
