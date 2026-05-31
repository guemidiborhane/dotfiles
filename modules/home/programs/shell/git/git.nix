{ self, ... }:
{
  flake.modules.homeManager.programs-git =
    { pkgs, user, ... }:
    {
      imports = with self.modules.homeManager; [
        lazygit
        delta
        git-crypt
      ];

      home.packages = [ pkgs.gitflow ];

      programs.git = {
        enable = true;
        package = pkgs.unstable.git;
        lfs.enable = true;
        settings = {
          user = {
            inherit (user) email name;
            signingkey = user.signingKey;
          };
          commit.gpgsign = true;
          gpg.format = "ssh";
          init.defaultBranch = "master";
          color.ui = true;
          core = {
            fileMode = false;
            abbrev = 8;
          };
          credential.helper = "store";
          pull.rebase = true;
          push = {
            default = "simple";
            autoSetupRemote = true;
          };
          alias = {
            st = "status -sb .";
            lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
            edit = "!git ls-files | fzf-tmux -p --reverse --preview 'bat -p --color=always {}'| xargs -r nvim";
          };
        };
      };

      home.sessionVariables = {
        INITIAL_COMMIT_MSG = "The same thing we do every night, Pinky - try to take over the world!";
        BATMAN_INITIAL_COMMIT_MSG = "Batman! (this commit has no parents)";
      };

      programs.fish.shellAbbrs = {
        nah = "git reset --hard;git clean -df";
        oops = "git commit --amend --no-edit";
        gaa = "git add .";
        gac = "git add . && git commit -m";
        gc = "git commit -m";
        gco = "git checkout";
        gcd = "git checkout develop";
        gcm = "git checkout master";
        gs = "git st";
        gd = "git diff";
        push = "git push";
        p = "git push";
        gpf = "git push -f";
        glog = "git lg";
        amend = "git commit --amend";
      };
    };
}
