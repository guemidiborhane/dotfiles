{ _, ... }:
{
  flake.homeModules.programs-yadm =
    { inputs, user, ... }:
    {
      imports = [ inputs.self.homeModules.yadm ];

      programs.yadm = {
        enable = true;
        repository = user.yadmRepo;
        autoClone = true;
      };
    };
}
