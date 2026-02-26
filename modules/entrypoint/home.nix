{ _, ... }:
{
  flake.homeModules.entrypoint-home =
    { inputs, ... }:
    {
      imports = [
        inputs.self.homeModules.inputs-nur
        inputs.self.homeModules.home-config

        inputs.self.homeModules.default-pkgs

        inputs.self.homeModules.programs-git
        inputs.self.homeModules.programs-yadm

        inputs.self.homeModules.shell
        inputs.self.homeModules.host-profile
      ];

      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
      };
      programs.home-manager.enable = true;
    };
}
