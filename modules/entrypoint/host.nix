{ _, ... }:
{
  flake.nixosModules.entrypoint-host =
    { inputs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        nix-config
        disko-config
        kernel
        locales
        common-host-configs
        zram-swap
        users
        hardware-host
        mount-disks
        networking
        virtualisation
        kanata
        base-devel
        pkgs-defaults
        services-openssh
        services-fstrim
        services-fwupd
        services-qbittorrent
        host-profile
        default-programs
      ];
    };
}
