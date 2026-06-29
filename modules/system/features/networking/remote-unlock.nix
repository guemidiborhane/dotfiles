{ lib, ... }:
{
  flake.modules.nixos.remote-unlock =
    { features, ... }:
    lib.mkIf (features.remoteUnlock or false) {
      boot = {
        kernelParams = [ "ip=dhcp" ];
        initrd = {
          availableKernelModules = [ "r8169" ];
          systemd.users.root.shell = "/usr/bin/systemd-tty-ask-password-agent";
          network = {
            enable = true;
            ssh = {
              enable = true;
              port = 22;
              authorizedKeys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAizWh/D3fQY7CT8onqVH4M0BJ7l5fpBsdCPvx3TsUo/ luks@warden"
              ];
              hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
            };
          };
        };
      };
    };
}
