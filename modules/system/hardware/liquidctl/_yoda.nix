{
  lib,
  stdenvNoCC,
  python3,
  makeWrapper,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.liquidctl
    ps.docopt
    ps.psutil
  ]);
in
stdenvNoCC.mkDerivation {
  pname = "liquidctl-yoda";
  version = python3.pkgs.liquidctl.version;

  src = python3.pkgs.liquidctl.src;

  dontConfigure = true;
  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 extra/yoda.py $out/bin/.yoda-unwrapped
    makeWrapper ${pythonEnv}/bin/python3 $out/bin/yoda \
      --add-flags $out/bin/.yoda-unwrapped
    runHook postInstall
  '';

  meta = with lib; {
    description = "Dynamically adjust liquidctl pump/fan speeds from sensor curves";
    homepage = "https://github.com/liquidctl/liquidctl/blob/main/extra/yoda.py";
    license = licenses.gpl3Plus;
    mainProgram = "yoda";
    platforms = platforms.linux;
  };
}
