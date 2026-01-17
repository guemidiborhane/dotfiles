{ cfg, ... }:
{
  enable = true;
  repository = cfg.user.yadmRepo;
  autoClone = true;
}
