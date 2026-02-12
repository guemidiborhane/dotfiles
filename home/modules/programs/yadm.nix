{ user, ... }:
{
  programs.yadm = {
    enable = true;
    repository = user.yadmRepo;
    autoClone = true;
  };
}
