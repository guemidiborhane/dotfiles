{
  lib,
  stdenv,
  shaderc,
  vulkan-headers,
  vulkan-loader,
  patchelf,
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
    nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [
      shaderc.bin
      patchelf
    ];
    buildInputs = (prev.buildInputs or [ ]) ++ [
      vulkan-headers
      vulkan-loader
    ];

    buildPhase = ''
      runHook preBuild
      # Build from a clean tree so no stale CPU object or .build-config stamp
      # survives into the VK=1 link — otherwise the engine silently ends up a
      # CPU build and `coli setup` reports it as (cpu, present).
      make -C c clean || true
      make -C c install VK=1 GLSLC=${shaderc.bin}/bin/glslc \
        ARCH=x86-64-v3 \
        DESTDIR=$out PREFIX= BINDIR=/bin LIBEXECDIR=/lib/colibri
      # Stage the compiled shaders beside the engines; `make install`
      # omits them and the default lookup is ./shaders next to the binary.
      install -d $out/lib/colibri/shaders
      install -m 644 c/shaders/*.spv $out/lib/colibri/shaders/
      runHook postBuild
    '';

    # Fail loudly if the result is not actually a Vulkan engine. colibri's
    # `coli setup` decides the backend from the binary itself: binary_backends()
    # (setup_flow.py) scans the engine for the literal "libvulkan.so" that
    # backend_vulkan.c's dlopen leaves in a VK=1 build, and prebuilt_runs()
    # additionally requires shaders/qmatmul.spv beside it. Without both it keeps
    # the engine as CPU ("the GPU build is not possible yet"). Assert here so a
    # botched VK build never ships as a silent CPU fallback.
    postBuild = (prev.postBuild or "") + ''
      engine=$out/lib/colibri/colibri
      if ! grep -q 'libvulkan\.so' "$engine"; then
        echo "colibri: engine $engine has no libvulkan.so reference — VK=1 build did not take effect" >&2
        exit 1
      fi
      if [ ! -f "$out/lib/colibri/shaders/qmatmul.spv" ]; then
        echo "colibri: shaders/qmatmul.spv missing — prebuilt_runs() would reject the Vulkan engine" >&2
        exit 1
      fi
    '';

    # Two separate things need the Vulkan loader, and they are made to find it
    # two different ways:
    #
    # 1. The engine ELFs dlopen libvulkan.so.1 by soname. Add the loader to each
    #    engine's RPATH — NOT by wrapping the binary. `coli setup` reads the
    #    backend from the engine file itself (binary_backends() in setup_flow.py
    #    scans it for "libvulkan.so"); a wrapper script would replace the ELF
    #    with a shell stub carrying no such string, so colibri would misread a
    #    Vulkan engine as CPU. RPATH keeps the ELF (and its loader reference)
    #    intact.
    #
    # 2. `coli setup`'s GPU probe is a *Python* child (setup_hw.py --vulkan-probe)
    #    that does ctypes.CDLL("libvulkan.so.1"). Python has no RPATH, so the
    #    probe can only find the loader through LD_LIBRARY_PATH — and the loader
    #    can only find the ICD (the actual driver) through the manifest search
    #    path. Wrapping the `coli` launcher (a Python entry point, not an engine)
    #    is safe for detection and is the only way to give that child the right
    #    environment whether it runs from the service or a manual `coli setup`.
    #    XDG_DATA_DIRS (not VK_DRIVER_FILES) carries the ICD dir, because the
    #    Vulkan loader ignores VK_DRIVER_FILES under elevated privileges — which
    #    `sudo -u colibri` and the hardened unit both count as.
    #
    # The ICD/driver live at the runtime path /run/opengl-driver/{lib,share},
    # which cannot be an RPATH or baked into the store, so they are referenced
    # by that literal path here and populated by hardware.graphics.enable.
    postFixup = (prev.postFixup or "") + ''
      for engine in \
        colibri deepseek_v4 deepseek_v41 glm53 inkling kimi_k3 laya mimo \
        olmoe qwen36 qwen38 qwenimage gliner_decide; do
        f=$out/lib/colibri/$engine
        [ -f "$f" ] || continue
        patchelf --add-rpath "${vulkan-loader}/lib" "$f"
      done

      wrapProgram $out/bin/coli \
        --prefix LD_LIBRARY_PATH : "${vulkan-loader}/lib:/run/opengl-driver/lib" \
        --suffix XDG_DATA_DIRS : "/run/opengl-driver/share"
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
