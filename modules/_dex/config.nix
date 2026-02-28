{ inputs }:
let
  loader = import ./configs;
  inherit (loader) defaults hosts;

  getHost = import ./getHost.nix;
in
{
  metadata = {
    repository = "https://github.com/guemidiborhane/nixos-config";
    stateVersion = "25.11";
  };

  hosts = builtins.attrValues (builtins.mapAttrs getHost hosts);

  systems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];
  defaultSystem = defaults.host.system;

  hostModules = [ inputs.self.nixosModules.entrypoint-host ];
  homeModules = [ inputs.self.homeModules.entrypoint-home ];
}
