{ ... }: {
  enable = true;
  shellInit = ''
    fish_add_path ~/.local/bin ~/.krew/bin
  '';
  interactiveShellInit = ''
    dr --completion fish | source
    fish_vi_key_bindings
  '';
}
