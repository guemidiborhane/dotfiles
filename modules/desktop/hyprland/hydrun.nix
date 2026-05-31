{ _, ... }:
{
  flake.modules.homeManager.hydrun =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      pname = "hydrun";
      runtimeDeps = with pkgs; [
        coreutils # mktemp, basename, cat
        util-linux # uuidgen
        jq # hyprctl client JSON parsing
        hyprland # hyprctl
      ];

      hydrun = pkgs.stdenv.mkDerivation {
        inherit pname;
        version = "0-unstable";

        src = ./scripts/hydrun.sh;
        dontUnpack = true;

        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          runHook preInstall
          install -Dm755 $src $out/bin/hydrun
          wrapProgram $out/bin/hydrun \
            --prefix PATH : ${lib.makeBinPath runtimeDeps} \
            --set-default HYDRUN_PROG_NAME ${pname}
          runHook postInstall
        '';

        meta = {
          mainProgram = pname;
          description = "Launch programs as systemd transient units with Hyprland dispatch support";
          platforms = lib.platforms.linux;
        };
      };
    in
    {
      home.packages = [ hydrun ];

      programs.fish = {
        shellAliases.dr = lib.getExe hydrun;

        interactiveShellInit = lib.mkAfter /* fish */ ''
          if not functions -q __hydrun_after_doubledash
            ${lib.getExe hydrun} --completion fish | source
          end
        '';
      };
    };
}
