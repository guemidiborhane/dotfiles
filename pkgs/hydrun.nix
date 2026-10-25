{
  lib,
  stdenv,
  makeWrapper,
  coreutils,
  util-linux,
  jq,
  hyprland,
}:

let
  pname = "hydrun";

  # Everything the script shells out to is put on its PATH:
  #   coreutils  -> mktemp, basename, cat
  #   util-linux -> uuidgen
  #   jq         -> hyprctl client JSON parsing
  #   hyprland   -> hyprctl (dispatch actions). Defaults to nixpkgs hyprland;
  #                 consumers can .override it with their own finalPackage.
  runtimeDeps = [
    coreutils
    util-linux
    jq
    hyprland
  ];
in
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable";

  src = ./hydrun.sh;
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/hydrun
    wrapProgram $out/bin/hydrun \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set-default HYDRUN_PROG_NAME ${pname}
    runHook postInstall
  '';

  meta = {
    description = "Launch programs as systemd transient units with Hyprland dispatch support";
    mainProgram = pname;
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
