{ self, ... }:
{
  flake-file.inputs = {
    microvm.url = "github:microvm-nix/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.caches.microvm = {
    url = "https://microvm.cachix.org";
    key = "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=";
  };

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

      iface = "microvm";
      IPv4Prefix = "192.33.58";
      IPv4Gateway = "${IPv4Prefix}.1";
      IPv4s = builtins.listToAttrs (
        lib.imap0 (index: name: {
          inherit name;
          value = "${IPv4Prefix}.${toString (3 + index)}";
        }) cfg.vms
      );

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
                vcpu = vm.hardware.vcpu or 4;
                mem = (vm.hardware.ram or 8) * 1024;
                vsock.cid = 900 + index;

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

      microvm.vms = builtins.listToAttrs (lib.imap0 mkVM cfg.vms);

      systemd.services."microvm-net" =
        let
          forEachVM = fn: map fn cfg.vms;
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
        '') cfg.vms;
        nat = {
          enable = true;
          internalInterfaces = [ iface ];
          externalInterface = cfg.externalInterface or "wlp2s0";
        };
      };
    };
}
