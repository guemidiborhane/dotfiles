{ self, ... }:
{
  flake.homeModules.programs-yadm =
    { user, lib, ... }:
    {
      imports = [ self.homeModules.yadm ];

      programs.yadm = lib.mkIf (user ? yadmRepo && user.yadmRepo != "") {
        enable = true;
        repository = user.yadmRepo;
        autoClone = true;
      };
    };
}
