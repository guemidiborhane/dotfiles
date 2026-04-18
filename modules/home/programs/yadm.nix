{ self, ... }:
{
  flake.modules.homeManager.programs-yadm =
    { user, lib, ... }:
    {
      imports = [ self.modules.homeManager.yadm ];

      programs.yadm = lib.mkIf (user ? yadmRepo && user.yadmRepo != "") {
        enable = true;
        repository = user.yadmRepo;
        autoClone = true;
      };
    };
}
