{
  programs.ghostty = {
    enable = false;
    systemd.enable = true;

    installVimSyntax = true;
    installBatSyntax = true;
  };
}
