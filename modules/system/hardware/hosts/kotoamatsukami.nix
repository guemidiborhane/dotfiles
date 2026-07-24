{ self, ... }:
{
  flake.modules.nixos.hardware-kotoamatsukami =
    {
      config,
      lib,
      modulesPath,
      hardware,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        self.modules.nixos.hardware-liquidctl
      ];

      boot = {
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
        kernelParams = [
          "memmap=64K$0x0000000712f10000"
          "memmap=32K$0x000000071b010000"
          "memmap=32K$0x0000000726978000"
          "memmap=8K$0x0000000446e76fb0"
          "memmap=8K$0x00000007b14916b0"
          "memmap=8K$0x00000007b28ad6b0"
          "memmap=9180K$0x00000007b42517b0"
          "memmap=8K$0x00000007ba118430"
          "memmap=8K$0x00000007bbb697b0"

          "memtest=1"
          "amd_pstate=active"
        ];

        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "uas"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      services.liquidctl = {
        enable = true;
        match = "H115i";
        curves = [
          {
            type = "fan";
            sensor = "k10temp.tctl";
            points = [
              [ 0 0 ]
              [ 40 0 ]
              [ 50 25 ]
              [ 60 40 ]
              [ 70 60 ]
              [ 85 100 ]
            ];
          }
        ];
      };
    };
}
