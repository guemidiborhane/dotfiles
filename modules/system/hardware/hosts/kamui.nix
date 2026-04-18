{ self, ... }:
{
  flake.modules.nixos.hardware-kamui =
    {
      inputs,
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        self.modules.nixos.hardware-thinkfan
      ];
      boot = {
        kernelParams = [
          "mem_sleep_default=s2idle"
          "amdgpu.reset_method=4"
        ];
        kernelModules = [
          "kvm-amd"
          "amdgpu"
        ];
        extraModulePackages = [ ];

        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "thunderbolt"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ "dm-snapshot" ];
        };
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
