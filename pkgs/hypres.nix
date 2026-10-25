{
  lib,
  writeScriptBin,
  python3,
}:

let
  # tomli is only needed to parse the generated commands.toml on Python < 3.11;
  # 3.11+ has tomllib in the stdlib.
  python = python3.withPackages (
    ps: lib.optionals (lib.versionOlder python3.version "3.11") [ ps.tomli ]
  );

  hypres = writeScriptBin "hypres" ''
    #!${python}/bin/python3
    ${builtins.readFile ./hypres.py}
  '';
in
hypres
// {
  meta = {
    description = "Save and restore Hyprland sessions via the socket2 IPC event stream";
    mainProgram = "hypres";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
