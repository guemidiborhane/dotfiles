{ lib, ... }:
{
  flake.nixosModules.networking-remote-unlock =
    { features, ... }:
    lib.mkIf (features.remoteUnlock or false) {
      boot.kernelParams = [ "ip=dhcp" ];
      boot.initrd = {
        availableKernelModules = [ "r8169" ];
        network = {
          enable = true;
          ssh = {
            enable = true;
            port = 22;
            authorizedKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAizWh/D3fQY7CT8onqVH4M0BJ7l5fpBsdCPvx3TsUo/ luks@warden"
            ];
            hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
            shell = "/bin/cryptsetup-askpass";
          };
        };
      };
    };
}
