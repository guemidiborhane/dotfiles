{ cfg, ... }:
{
  programs.yadm = {
    enable = true;
    repository = cfg.user.yadmRepo;
    autoClone = true;
  };
}
