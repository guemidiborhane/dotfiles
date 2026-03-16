{ _, ... }:
{
  flake.homeModules.programs-yadm =
    {
      inputs,
      user,
      lib,
      ...
    }:
    {
      imports = [ inputs.self.homeModules.yadm ];

      programs.yadm = lib.mkIf (user ? yadmRepo && user.yadmRepo != "") {
        enable = true;
        repository = user.yadmRepo;
        autoClone = true;
      };
    };
}
