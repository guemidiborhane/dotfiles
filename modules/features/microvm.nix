{ self, lib, ... }:
{
  flake-file.inputs = {
    microvm.url = "github:microvm-nix/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.caches.microvm = {
    url = "https://microvm.cachix.org";
    key = "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=";
  };

  flake.dex.rules = [
    # A microVM host must declare its own resources.
    (
      { hardware, ... }:
      lib.optionals hardware.isMicroVM (
        lib.optional (!(hardware ? vcpu)) "microvm host must set hardware.vcpu."
        ++ lib.optional (!(hardware ? ram)) "microvm host must set hardware.ram."
      )
    )
    # A physical host's VMs must fit within its RAM. Each VM's effective ram
    # (a `features.microvm.<vm>.resources` override, else the VM's own
    # hardware.ram) must not exceed the host's ram, and the VMs must not
    # collectively overcommit it.
    (
      { features, hardware, ... }:
      let
        mv = features.microvm or { };
        # Every key under `features.microvm` is a VM name except these.
        reservedKeys = [ "externalInterface" ];
        vmNames = builtins.attrNames (builtins.removeAttrs mv reservedKeys);
      in
      lib.optionals ((vmNames != [ ]) && (hardware ? ram)) (
        let
          hostRam = hardware.ram;
          vmRam =
            vmName:
            let
              vm = self.dex.getHost vmName;
            in
            mv.${vmName}.resources.ram or vm.hardware.ram or 2;

          perVM = lib.concatMap (
            vmName:
            let
              ram = vmRam vmName;
            in
            lib.optional (
              ram > hostRam
            ) "microvm '${vmName}' ram (${toString ram}) exceeds host ram (${toString hostRam})."
          ) vmNames;

          total = lib.foldl' (acc: vmName: acc + vmRam vmName) 0 vmNames;
          overcommit = lib.optional (total > hostRam) (
            "microvm ram overcommits host: VMs total ${toString total} > host ram ${toString hostRam}."
          );
        in
        perVM ++ overcommit
      )
    )
    # Every key under `features.microvm` (minus reserved keys) must reference a
    # host of type "vm", and each of that VM's shares must be a [host, guest]
    # tuple.
    (
      { name, features, ... }:
      let
        mv = features.microvm or { };
        reservedKeys = [ "externalInterface" ];
        vmNames = builtins.attrNames (builtins.removeAttrs mv reservedKeys);

        hosts = self.tomlConfigs.hosts;
        isVM = vmName: (hosts.${vmName}.type or null) == "vm";

        vmRefErrors = lib.concatMap (
          vmName:
          lib.optional (
            !(isVM vmName)
          ) "host '${name}': features.microvm references unknown VM \"${vmName}\"."
        ) vmNames;

        shareErrors = lib.concatMap (
          vmName:
          lib.concatLists (
            lib.imap0 (
              i: share:
              lib.optional (
                !(builtins.isList share) || builtins.length share != 2
              ) "host '${name}': features.microvm.${vmName}.shares[${toString i}] must be a [host, guest] tuple."
            ) (mv.${vmName}.shares or [ ])
          )
        ) vmNames;
      in
      vmRefErrors ++ shareErrors
    )
  ];

  flake.modules.nixos.microvm =
    ctx@{
      inputs,
      lib,
      pkgs,
      features,
      ...
    }:
    let
      cfg = features.microvm or { };

      # Keys under `features.microvm` that are not VM names. Every other key is
      # a VM this host deploys, each holding host-specific `{ resources, shares
      # }` overrides (mirrors how `host.users` keys are usernames).
      reservedKeys = [
        "externalInterface"
      ];

      # VMs run by this host, sorted for a deterministic index. IP/CID stability
      # across edits does not matter: VMs are reached by `<name>.uvm` via
      # `networking.extraHosts` below, not by a fixed address.
      vmNames = lib.naturalSort (builtins.attrNames (builtins.removeAttrs cfg reservedKeys));

      iface = "microvm";
      IPv4Prefix = "192.33.58";
      IPv4Gateway = "${IPv4Prefix}.1";
      IPv4s = builtins.listToAttrs (
        lib.imap0 (index: name: {
          inherit name;
          value = "${IPv4Prefix}.${toString (3 + index)}";
        }) vmNames
      );

      # Turn a host path into a stable virtiofs tag, e.g. `/host/nixos` →
      # `host_nixos`.
      pathToShareKey =
        path:
        let
          str = toString path;
          cleaned = lib.removeSuffix "/" (lib.removePrefix "/" str);
        in
        lib.toLower (lib.replaceStrings [ "/" ] [ "_" ] cleaned);

      mkMac =
        name:
        let
          hash = builtins.hashString "sha256" name;
          c = off: builtins.substring off 2 hash;
        in
        "${builtins.substring 0 1 hash}2:${c 2}:${c 4}:${c 6}:${c 8}:${c 10}";

      mkVM =
        index: vmName:
        let
          vm = self.dex.getHost vmName;
          inherit (vm.config) name;

          IPv4Addr = IPv4s.${name};

          # Host-specific overrides for this VM, keyed per-VM under
          # `features.microvm.<vmName>` on the deploying host.
          override = cfg.${vmName} or { };

          # A physical host may override a VM's resources for its own
          # deployment via `features.microvm.<vmName>.resources`; fall back to
          # the VM's own hardware, then to the module defaults.
          resources = override.resources or { };
          vcpu = resources.vcpu or vm.hardware.vcpu or 2;
          ram = resources.ram or vm.hardware.ram or 2;

          # Shares the VM declares as its own defaults, overlaid with the
          # deploying host's shares. Each share is a [host, guest] tuple; a host
          # share replaces a VM default with the same guest mount point (host
          # wins), the rest are unioned.
          vmShares = vm.config.shares or [ ];
          hostShares = override.shares or [ ];
          mergedShares = builtins.attrValues (
            builtins.listToAttrs (map (s: lib.nameValuePair (builtins.elemAt s 1) s) (vmShares ++ hostShares))
          );

          shares = [
            {
              proto = "virtiofs";
              tag = "ro-store";
              readOnly = true;
              # a host's /nix/store will be picked up so that no
              # squashfs/erofs will be built for it.
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
            }
          ]
          ++ (map (share: {
            proto = "virtiofs";
            tag = pathToShareKey (builtins.elemAt share 0);
            source = builtins.elemAt share 0;
            mountPoint = builtins.elemAt share 1;
          }) mergedShares);
        in
        lib.nameValuePair vm.config.name {
          inherit pkgs;

          autostart = vm.autostart or false;

          specialArgs = {
            inherit inputs;

            inherit (ctx) metadata h secrets;
            inherit (ctx) homeModules;

            inherit (vm) features hardware;
            inherit (vm) users;

            host = vm.config;
          };

          config =
            { lib, pkgs, ... }:
            {
              imports = [ self.modules.nixos.entrypoint ];

              systemd = {
                network = {
                  networks."10-${iface}" = {
                    matchConfig.MACAddress = mkMac name;
                    networkConfig = {
                      Address = "${IPv4Addr}/24";
                      Gateway = IPv4Gateway;
                    };
                  };
                };
              };

              microvm = {
                inherit vcpu shares;
                mem = ram * 1024;
                vsock.cid = 900 + index;

                # volumes = [
                #   {
                #     mountPoint = "/tmp";
                #     image = "tmp.img";
                #     size = 16384;
                #   }
                # ];

                interfaces = [
                  {
                    type = "tap";
                    id = iface;
                    mac = mkMac name;
                  }
                ];
              };
            };
        };
    in
    {
      imports = [ inputs.microvm.nixosModules.host ];

      microvm.vms = builtins.listToAttrs (lib.imap0 mkVM vmNames);

      systemd.services."microvm-net" =
        let
          forEachVM = fn: map fn vmNames;
        in
        {
          description = "Assign gateway IP to the microvm tap";
          after = forEachVM (name: "microvm-tap-interfaces@${name}.service");
          before = forEachVM (name: "microvm@${name}.service");
          partOf = forEachVM (name: "microvm@${name}.service");
          wantedBy = forEachVM (name: "microvm@${name}.service");
          serviceConfig.Type = "oneshot";
          script = ''
            ${pkgs.iproute2}/bin/ip addr replace ${IPv4Gateway}/24 dev ${iface}
          '';
        };

      networking = {
        extraHosts = lib.concatMapStrings (name: ''
          ${IPv4s.${name}} ${name}.uvm
        '') vmNames;
        nat = {
          enable = true;
          internalInterfaces = [ iface ];
          externalInterface = cfg.externalInterface or "wlp2s0";
        };
      };
    };
}
