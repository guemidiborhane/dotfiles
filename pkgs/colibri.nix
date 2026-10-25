{
  lib,
  stdenv,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  buildNpmPackage,
  # The colibri flake input. Both the upstream derivation and the source tree
  # (for web/dist) are derived from it, so only this single reference is passed.
  colibri,
  # Toggles:
  withVulkan ? true,
  withWeb ? true,
  # The dashboard (web/dist) is a build artifact upstream's derivation doesn't
  # produce; bump when the upstream `web/` lockfile changes.
  npmDepsHash ? "sha256-dSBj0ugEctPY18JWe5ajsVQFy2kWvgLYLzuwIs39HLs=",
}:
let
  # Upstream's CPU/Metal derivation and source tree, both from the flake input.
  colibriBase = colibri.packages.${stdenv.hostPlatform.system}.colibri;
  colibriSrc = colibri;

  # Rebuild upstream's derivation with VK=1. `make install` stages the engines
  # under $out/lib/colibri but NOT the SPIR-V shaders, and the engines look for
  # them in ./shaders next to the binary — so copy them there. The Vulkan
  # loader is dlopen'd at runtime (not linked), so it is added to the wrapped
  # LD_LIBRARY_PATH alongside /run/opengl-driver/lib, which NixOS populates with
  # the Mesa/driver Vulkan ICD when hardware.graphics.enable is set.
  colibriVulkan = colibriBase.overrideAttrs (prev: {
    pname = "colibri-vulkan";

    # glslc lives in shaderc's split `bin` output, not the default `out`.
    nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ shaderc.bin ];
    buildInputs = (prev.buildInputs or [ ]) ++ [
      vulkan-headers
      vulkan-loader
    ];

    buildPhase = ''
      runHook preBuild
      make -C c install VK=1 GLSLC=${shaderc.bin}/bin/glslc \
        ARCH=x86-64-v3 \
        DESTDIR=$out PREFIX= BINDIR=/bin LIBEXECDIR=/lib/colibri
      # Stage the compiled shaders beside the engines; `make install`
      # omits them and the default lookup is ./shaders next to the binary.
      install -d $out/lib/colibri/shaders
      install -m 644 c/shaders/*.spv $out/lib/colibri/shaders/
      runHook postBuild
    '';

    # The engines dlopen libvulkan.so.1 by soname at runtime. Make the loader +
    # ICD findable: $out/bin/coli (the makeWrapper the base installPhase
    # created) is re-wrapped so its engine subprocesses inherit
    # LD_LIBRARY_PATH; the engine's own $out/bin/colibri symlink resolves to
    # $out/lib/colibri/colibri, so wrap that directly.
    postFixup = (prev.postFixup or "") + ''
      wrapProgram $out/bin/coli \
        --suffix LD_LIBRARY_PATH : "${vulkan-loader}/lib:/run/opengl-driver/lib"
      wrapProgram $out/lib/colibri/colibri \
        --suffix LD_LIBRARY_PATH : "${vulkan-loader}/lib:/run/opengl-driver/lib"
    '';
  });

  # The dashboard (web/dist) is a build artifact upstream's derivation doesn't
  # produce, so `coli setup` tries to fetch it and copy it into $out at runtime
  # — impossible in the store. Build it here and stage it at
  # lib/colibri/web/dist, the first path both setup_flow.py and
  # openai_server.py probe; ensure_web_dist() then returns early.
  colibriWeb = buildNpmPackage {
    pname = "colibri-web";
    version = colibriBase.version;
    src = colibriSrc + "/web";
    inherit npmDepsHash;
    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

  withWebDist =
    drv:
    drv.overrideAttrs (prev: {
      postInstall = (prev.postInstall or "") + ''
        install -d $out/lib/colibri/web
        cp -r ${colibriWeb} $out/lib/colibri/web/dist
      '';
    });

  engine = if withVulkan then colibriVulkan else colibriBase;
in
if withWeb then withWebDist engine else engine
