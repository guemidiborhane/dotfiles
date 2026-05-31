{ self, ... }:
{
  flake.modules.homeManager.tmux =
    { pkgs, ... }:
    {
      imports = with self.modules.homeManager; [ programs-sesh ];
      home.packages = with pkgs; [ tmux ];
      dex.dotfiles.".config/tmux" = ./.;

      programs.fish = {
        shellAliases = {
          wn = "tn workshop";
        };
        shellAbbrs = {
          tp = "tmux_popup";
        };
        loginShellInit = /* fish */ ''
          if test $status -eq 0 -a -z "$TMUX" -a -n "$SSH_TTY"
              exec sh -c 'tmux -u new-session -As workshop'
          end
        '';
        functions = {
          tn = {
            argumentNames = [ "session_name" ];
            body = /* fish */ ''
              set -q session_name[1]; or set session_name (basename $PWD)

              if not tmux has-session -t "$session_name"
                tmux -N new-session -ds "$session_name"

                set -l timeout 50
                while not tmux has-session -t "$session_name"; and test $timeout -gt 0
                  sleep 0.1
                  set timeout (math $timeout - 1)
                end

                if test $timeout -eq 0
                  echo "Timeout waiting for tmux session '$session_name'" >&2
                  return 1
                end
              end

              if test -z "$TMUX"
                tmux attach-session -t "$session_name"
              else
                tmux switch-client -t "$session_name"
              end
            '';
          };

          tmux_popup = {
            description = "Run command in tmux popup or directly if not in tmux";
            body = /* fish */ ''
              if test (count $argv) -eq 0
                echo "Usage: tmux_popup <command> [args...]" >&2
                echo "Example: tmux_popup yadm enter lazygit" >&2
                return 1
              end

              if test -z "$TMUX"; or test -z "$TMUX_PANE"
                set -l filtered_args
                set -l skip_next false

                for arg in $argv
                  if test "$skip_next" = true
                    set skip_next false
                    continue
                  end

                  switch $arg
                    case -w -h -x -y -S -t -d
                      set skip_next true
                    case '-*'
                      continue
                    case '*'
                      set -a filtered_args $arg
                  end
                end

                $filtered_args
              else
                tmux popup -d '#{pane_current_path}' -E $argv
              end
            '';
          };
        };
      };

      systemd.user = {
        slices.tmux = {
          Unit.Description = "tmux slice";
        };

        services.tmux = {
          Unit = {
            Description = "tmux server daemon";
            Documentation = "man:tmux(1)";
          };

          Service = {
            Type = "simple";
            ExecStart = "${pkgs.fish}/bin/fish -c 'exec ${pkgs.tmux}/bin/tmux -D'";
            ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
            Slice = "tmux.slice";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };
}
