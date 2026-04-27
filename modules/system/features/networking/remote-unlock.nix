{ lib, ... }:
{
  flake.modules.nixos.features-remote-unlock =
    { features, ... }:
    lib.mkIf (features.remoteUnlock or false) {
      boot.initrd = {
        availableKernelModules = [ "r8169" ];
        systemd = {
          network = {
            enable = true;
            networks."10-lan" = {
              enable = true;
              matchConfig.Name = "enp*";
              networkConfig.DHCP = "yes";
            };
          };
        };
        network = {
          enable = true;
          flushBeforeStage2 = true;
          ssh = {
            enable = true;
            port = 22;
            authorizedKeys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAizWh/D3fQY7CT8onqVH4M0BJ7l5fpBsdCPvx3TsUo/ luks@warden"
            ];
            hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
            shell = "/usr/bin/systemd-tty-ask-password-agent";
          };
        };
      };
    };
}
