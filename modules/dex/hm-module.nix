{ _, ... }:
{
  flake.modules.homeManager.dex =
    { pkgs, metadata, ... }:
    let
      dexPkg = pkgs.writeScriptBin "dex" /* sh */ ''
        #!/usr/bin/env sh
        exec ${pkgs.just}/bin/just \
          --justfile "${metadata.flake}/Justfile" \
          --working-directory "${metadata.flake}" \
          "$@"
      '';
      yayPkg = pkgs.writeScriptBin "yay" /* sh */ ''
        #!/usr/bin/env sh
        setsid ${pkgs.kitty}/bin/kitty sh -c '
          "${dexPkg}/bin/dex" yay "$@"
          printf "\n[Press Enter to exit]"
          read -r _
        ' _ "$@" </dev/null >/dev/null 2>&1 &
        disown
      '';
    in
    {
      programs.fish = {
        shellAbbrs = {
          ds = "dex switch";
          db = "dex boot";
          dt = "dex test";
        };

        completions = {
          dex = "complete -c dex --wraps just";
          yay = "complete -c yay --wraps dex";
        };
      };

      home.packages = [
        dexPkg
        yayPkg
      ];
    };
}
