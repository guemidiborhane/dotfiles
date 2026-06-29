{ _, ... }:
{
  flake.modules.homeManager.sesh =
    { lib, pkgs, ... }:
    let
      pkg = pkgs.stable.sesh;
    in
    {
      programs.sesh = {
        enable = true;
        package = pkg;
        enableTmuxIntegration = false;
        enableAlias = false;
        settings = {
          default_session = {
            startup_command = "ls";
            preview_command = "${lib.getExe pkgs.eza} --all --git --icons --color=always {}";
          };
          window = [
            {
              name = "nixos";
              path = "~/.config/nixos";
              startup_script = "exec $EDITOR";
            }
          ];
          session = [
            {
              name = "system";
              disable_startup_command = true;
              windows = [
                "nixos"
                "dotfiles"
              ];
            }
          ];
        };
      };

      home.packages = [
        (pkgs.writeScriptBin "s" /* sh */ ''
          #!/usr/bin/env sh
          ${lib.getExe pkg} connect "$(
            ${lib.getExe pkg} list "$@" --icons | fzf-tmux -p 80%,70% \
              --no-sort --ansi --border-label ' sesh ' --prompt '󱐋  ' \
              --header '  ^a all ^w tmux ^c configs ^x zoxide ^d tmux kill ^f find' \
              --bind 'tab:down,btab:up' \
              --bind 'ctrl-a:change-prompt(󱐋  )+reload(sesh list -H --icons)' \
              --bind 'ctrl-w:change-prompt(  )+reload(sesh list -t --icons)' \
              --bind 'ctrl-c:change-prompt(  )+reload(sesh list -c --icons)' \
              --bind 'ctrl-x:change-prompt(  )+reload(sesh list -z --icons)' \
              --bind 'ctrl-f:change-prompt(  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
              --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(󱐋  )+reload(sesh list --icons)' \
              --preview-window 'bottom:55%' \
              --preview 'sesh preview {}'
          )"
        '')
      ];
    };
}
