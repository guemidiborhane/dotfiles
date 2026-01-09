{ pkgs, ... }: {
  enable = true;
  # package = pkgs.unstable.ghostty;
  systemd.enable = true;

  installVimSyntax = true;
  installBatSyntax = true;
}
