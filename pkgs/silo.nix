{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  pnpm_10,
  nodejs_24,
  pkg-config,
  vips,
  makeWrapper,
  jellyfin-ffmpeg,
  git,
}:

# Silo — self-hosted media server for films, series, audiobooks, ebooks,
# podcasts, and manga. https://github.com/Silo-Server/silo-server
#
# Built natively from source: the React frontend (web/) is built with pnpm in a
# separate derivation and staged into web/dist so the Go binary embeds it
# (//go:embed all:dist), then the server is compiled with CGO for h2non/bimg
# (libvips) and go-sqlite3.
#
# This packages the core server (cmd/silo) only. Upstream's Docker image also
# runs a Node-based jellyfin-web installer at runtime for the optional Jellyfin
# compatibility UI; that is deliberately omitted to keep the build pure.
#
# Runtime needs PostgreSQL (with pgvector) and optionally Redis — provisioned by
# modules/features/services/silo.nix. ffmpeg (jellyfin-ffmpeg) is wrapped onto
# PATH for transcoding.
#
# When bumping `version`/`rev`, set `src.hash`, `frontend.pnpmDeps.hash` and
# `vendorHash` to lib.fakeHash in turn and replace each with the value the
# failing build reports.
let
  pname = "silo";
  version = "0-unstable-2026-10-29";

  src = fetchFromGitHub {
    owner = "Silo-Server";
    repo = "silo-server";
    rev = "0225a0589112fcc3d35a71e2d5b46fe9b55b76d1";
    hash = "sha256-sjhKpuKsBiP8Z4chOHP1tpojAJqJpgoY87KozlW8V1Y=";
  };

  # The embedded React frontend, built on its own so the pnpm toolchain stays
  # out of the Go vendor/build derivations.
  frontend = stdenv.mkDerivation (finalAttrs: {
    pname = "${pname}-frontend";
    inherit version src;

    # The project's lockfile is pnpm 10; pnpm 12 (the default fetchPnpmDeps /
    # pnpmConfigHook) can't do a frozen install against it, so use the
    # version-specific helpers from pnpm_10.
    pnpmDeps = pnpm_10.fetchDeps {
      inherit (finalAttrs) pname version src;
      sourceRoot = "${finalAttrs.src.name}/web";
      fetcherVersion = 5;
      hash = "sha256-jt4aM2NiHfdbTRCmXx3xco+eRyPrGRgR1aDWE6OAh9M=";
    };
    pnpmRoot = "web";

    nativeBuildInputs = [
      nodejs_24
      pnpm_10.configHook
    ];

    # `pnpm run build` is `node scripts/typecheck.mjs && vite build`; the
    # typecheck step execve()s the `tsrs` native binary, which the sandbox
    # rejects. Type-checking isn't needed to produce the bundle, so run vite
    # directly.
    buildPhase = ''
      runHook preBuild
      pushd web
      pnpm exec vite build
      popd
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r web/dist $out
      runHook postInstall
    '';
  });
in
buildGoModule {
  inherit pname version src;

  # Only the server command; the repo holds many auxiliary cmd/ tools.
  subPackages = [ "cmd/silo" ];

  vendorHash = "sha256-dF0P+DOfOuimgbVW8/a1kx5I3gb+TEauBK7HpZ5aD6w=";

  # h2non/bimg (libvips) and mattn/go-sqlite3 require cgo.
  env.CGO_ENABLED = "1";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ vips ];

  # Stage the prebuilt frontend where //go:embed all:dist expects it.
  preBuild = ''
    rm -rf web/dist
    cp -r ${frontend} web/dist
    chmod -R u+w web/dist
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/Silo-Server/silo-server/internal/buildinfo.revisionOverride=${src.rev}"
  ];

  # Transcoding shells out to ffmpeg; git is used for some runtime operations.
  postInstall = ''
    wrapProgram $out/bin/silo \
      --prefix PATH : ${
        lib.makeBinPath [
          jellyfin-ffmpeg
          git
        ]
      }
  '';

  # The package tree is large and tests expect Postgres/Redis; skip them.
  doCheck = false;

  meta = {
    description = "Self-hosted media server for films, series, audiobooks, ebooks, podcasts, and manga";
    homepage = "https://github.com/Silo-Server/silo-server";
    license = lib.licenses.agpl3Plus;
    mainProgram = "silo";
    platforms = lib.platforms.linux;
  };
}
