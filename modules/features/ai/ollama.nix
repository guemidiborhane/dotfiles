_: {
  flake.unfreePackages = [
    "cuda_cudart"
    "cuda_nvcc"
    "libnvvm"
    "cccl"
    "cuda_crt"
    "libcublas"
    "cuda_nvrtc"
  ];

  flake.modules.nixos.ollama =
    {
      lib,
      pkgs,
      hardware,
      features,
      ...
    }:
    let
      ollama = features.ollama or { };

      package =
        if hardware.hasNvidia then
          pkgs.ollama-cuda
        else if hardware.hasAMDGPU then
          pkgs.ollama-rocm
        else
          pkgs.ollama;

      # Some AMD iGPUs/dGPUs are functional under ROCm but not officially
      # detected. `gfxOverride` (e.g. "11.0.0") maps them onto a supported
      # LLVM target. Set it per-host via `features.ollama.gfxOverride`.
      gfxOverride = ollama.gfxOverride or "";

      # ollama drops integrated GPUs by default ("dropping integrated GPU;
      # to enable, set OLLAMA_IGPU_ENABLE=1"). Enable them on AMD by default
      # since the iGPU is the only GPU there; toggle via `features.ollama.igpu`.
      enableIgpu = ollama.igpu or hardware.hasAMDGPU;
    in
    {
      services.ollama = {
        enable = true;
        inherit package;

        rocmOverrideGfx = lib.mkIf (hardware.hasAMDGPU && gfxOverride != "") gfxOverride;

        environmentVariables = lib.mkIf enableIgpu {
          OLLAMA_IGPU_ENABLE = "1";
        };
      };
    };
}
