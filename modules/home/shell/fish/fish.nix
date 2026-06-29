{ _, ... }:
{
  flake.modules.homeManager.fish =
    { pkgs, lib, ... }:
    let
      functionsDir = ./functions;
      functionFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".fish" name) (
        builtins.readDir functionsDir
      );
      functions = lib.mapAttrs' (
        name: _: lib.nameValuePair "functions/${name}" (functionsDir + "/${name}")
      ) functionFiles;
    in
    {
      programs.fish = {
        enable = true;
        package = pkgs.unstable.fish;

        interactiveShellInit = /* fish */ ''
          fish_vi_key_bindings
          bind -M insert -m default jj backward-char force-repaint
        '';

        shellAliases = {
          cat = "bat --no-pager";
          clear = "command clear && fish_greeting";
          zid = "eza -D | xargs -I {} zoxide add {}";
          fast = "bunx -- fast-cli --single-line";
          which = "type -a";
          gzip = "pigz";
          tv = "tidy-viewer";
          sr = "steam-run";
        };

        shellAbbrs = {
          mv = "mv -iv";
          cp = "cp -riv";
          mkdir = "mkdir -vp";
          rmi = "rm -iv";
          c = "clear";
          n = "xdg-open";
          "n." = "xdg-open .";
          p1 = "ping 1.1.1.1";
          p8 = "ping 8.8.8.8";
          pp = "fish -P";
          hr = "hyprctl reload";
          watch = "watch -d -n 10";
        };
      };

      dex.dotfiles.".config/fish" = functions // {
        "conf.d" = ./conf;
      };
    };
}
