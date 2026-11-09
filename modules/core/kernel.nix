{ self, lib, ... }:
let
  # Closed domains for the kernel fields this module consumes. They live here,
  # beside the code that indexes them, because `kernel` is consumed in a single
  # module (see the colocation rule in modules/dex/dex.nix `flake.dex.rules`).
  #
  # Enums are constrained to what nix-cachyos-kernel actually packages for this
  # repo's usage, not the full mkCachyKernel arg domains:
  #   opti  -> prebuilt `linuxPackages-cachyos-*-lto-${opti}` (no v1/native)
  #   sched -> packaged `linux-cachyos-${sched}` config variants (no bare rt)
  #   lto   -> mkCachyKernel `lto` arg
  validKernelOpti = [
    "x86_64-v2"
    "x86_64-v3"
    "x86_64-v4"
    "zen4"
  ];
  validKernelSched = [
    "eevdf"
    "bore"
    "bmq"
    "rt-bore"
  ];
  validKernelLto = [
    "none"
    "thin"
    "full"
  ];
  # Valid keys of `availableKernels` below; both `host.kernel` and each
  # `host.additionalKernels` entry index into it.
  validKernels = [
    "linux-latest"
    "linux-lts"
    "linux-zen"
    "cachyos-lts"
    "cachyos-latest"
    "cachyos-custom"
  ];

  enumError =
    {
      field,
      value,
      valid,
    }:
    lib.optional (value != null && value != "" && !(builtins.elem value valid)) (
      "${field} must be one of [ ${lib.concatStringsSep ", " valid} ] (got \"${toString value}\")."
    );

  membershipErrors =
    {
      field,
      values,
      valid,
    }:
    map (v: "${field} references unknown \"${v}\".") (
      builtins.filter (v: !(builtins.elem v valid)) values
    );
in
{
  # Validate the kernel fields over each host's cascaded context, so the
  # effective merged value (defaults + per-host override) is what gets checked.
  flake.dex.rules = [
    (
      { config, features, ... }:
      let
        kernel = features.kernel or { };
      in
      (enumError {
        field = "features.kernel.opti";
        value = kernel.opti or null;
        valid = validKernelOpti;
      })
      ++ (enumError {
        field = "features.kernel.sched";
        value = kernel.sched or null;
        valid = validKernelSched;
      })
      ++ (enumError {
        field = "features.kernel.lto";
        value = kernel.lto or null;
        valid = validKernelLto;
      })
      ++ (enumError {
        field = "kernel";
        value = config.kernel or null;
        valid = validKernels;
      })
      ++ (membershipErrors {
        field = "additionalKernels";
        values = config.additionalKernels or [ ];
        valid = validKernels;
      })
    )
  ];

  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

  flake = {
    caches.cachyos-kernel = {
      url = "https://cache.lantian.pub/lantian";
      key = "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=";
    };

    overlays.cachyos-kernels = final: prev: {
      customKernels = builtins.listToAttrs (
        lib.mapAttrsToList (
          _: host:
          let
            inherit (host.features.kernel) lto sched opti;

            kernel = prev.cachyosKernels.linux-cachyos-latest;
            kernelName = "linux-cachyos-latest-${sched}-lto-${opti}";
            helpers = prev.callPackage "${self.inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
          in
          {
            name = kernelName;
            value = helpers.kernelModuleLLVMOverride (
              prev.linuxKernel.packagesFor (
                kernel.override {
                  inherit lto;

                  pname = kernelName;
                  cpusched = sched;
                  processorOpt = opti;
                  configVariant = "linux-cachyos-${sched}";
                }
              )
            );
          }
        ) (self.dex.hosts or { })
      );
    };

    modules.nixos.kernel =
      ctx@{ pkgs, lib, ... }:
      let
        inherit (ctx) inputs features host;
        inherit (features.kernel) opti sched;

        kernelName = host.kernel or "";
        availableKernels = {
          linux-latest = pkgs.linuxPackages_latest;
          linux-lts = pkgs.linuxPackages;
          linux-zen = pkgs.linuxPackages_zen;

          cachyos-lts = pkgs.cachyosKernels."linuxPackages-cachyos-lts-lto-${opti}";
          cachyos-latest = pkgs.cachyosKernels."linuxPackages-cachyos-bore-lto-${opti}";
          cachyos-custom = pkgs.customKernels."linux-cachyos-latest-${sched}-lto-${opti}";
        };
        overlay = kernelName: if kernelName == "cachyos-custom" then "default" else "pinned";
      in
      {
        specialisation = builtins.listToAttrs (
          map (kernelName: {
            name = kernelName;
            value = {
              configuration = {
                nixpkgs.overlays = [
                  inputs.nix-cachyos-kernel.overlays.${overlay kernelName}
                  self.overlays.cachyos-kernels
                ];
                boot.kernelPackages = lib.mkForce availableKernels.${kernelName};
              };
            };
          }) (host.additionalKernels or [ ])
        );

        boot.kernelPackages = lib.mkDefault (
          if kernelName != "" then availableKernels.${kernelName} else availableKernels.cachyos-latest
        );
        nixpkgs.overlays = [
          inputs.nix-cachyos-kernel.overlays.${overlay kernelName}
          self.overlays.cachyos-kernels
        ];
      };
  };
}
