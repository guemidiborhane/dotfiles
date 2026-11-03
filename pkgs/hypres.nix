{
  lib,
  stdenv,
  makeWrapper,
  writeScriptBin,
  python3,
  hyprland,
}:

let
  pname = "hypres";

  # tomli is only needed to parse the generated commands.toml on Python < 3.11;
  # 3.11+ has tomllib in the stdlib.
  python = python3.withPackages (
    ps: lib.optionals (lib.versionOlder python3.version "3.11") [ ps.tomli ]
  );

  unwrapped = writeScriptBin pname ''
    #!${python}/bin/python3
    ${builtins.readFile ./hypres.py}
  '';
in
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    # hypres shells out to hyprctl at runtime. Defaults to nixpkgs hyprland;
    # consumers can .override it with their own finalPackage.
    makeWrapper ${unwrapped}/bin/hypres $out/bin/hypres \
      --prefix PATH : ${lib.makeBinPath [ hyprland ]}
    runHook postInstall
  '';

  meta = {
    description = "Save and restore Hyprland sessions via the socket2 IPC event stream";
    mainProgram = pname;
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
