{ self, lib, ... }:
let
  bareMetalGuard = entry: { hardware, ... }: { ${entry} = [ hardware.isBareMetal ]; };
  microVMGuard = entry: { hardware, ... }: { ${entry} = [ hardware.isMicroVM ]; };

  isToggled = arg: (arg.enable or arg) == true;
  scopeGuard = scope: entry: (ctx: { ${entry} = [ (isToggled ctx.${scope}.${entry}) ]; });
  hardwareGuard = entry: scopeGuard "hardware" entry;
  featureGuard = entry: scopeGuard "features" entry;

  # The microvm host capability is enabled whenever the host declares at least
  # one VM as a key under `features.microvm` (every key but the reserved ones is
  # a VM name). Mirrors how a host's VMs are derived from attrset keys.
  microvmGuard =
    { features, ... }:
    let
      mv = features.microvm or { };
      vmNames = builtins.removeAttrs mv [ "externalInterface" ];
    in
    {
      microvm = [ (vmNames != { }) ];
    };

  # Selects at most one swap implementation from the `features.swap` string
  # ("zram" | "zswap" | "none"); the unselected module(s) are guarded off.
  swapGuard = { features, ... }: {
    zram-swap = [ (features.swap == "zram") ];
    zswap = [ (features.swap == "zswap") ];
  };
  hostHardware = { host, hardware, ... }: { "${host.name}-hardware" = [ hardware.isBareMetal ]; };
  nvidia = { hardware, ... }: { nvidia = [ hardware.hasNvidia ]; };
  hostProfile = { host, ... }: { "${host.type}-profile" = [ true ]; };
  nixosHardware = { hardware, ... }: { nixos-hardware = [ (hardware.nixos-hardware != "") ]; };

  nixosDefaults = [
    "dex-persist"
    "base-devel"
    "boot"
    "fish"
    hostProfile
    "locales"
    "neovim"
    "netbird"
    "networking"
    "nix-config"
    "nix-index-database"
    "nix-substituters"
    "resolved"
    "security"
    "users"
    "home-manager"
    "tty-autologin"
    "mount-disks"
    "packages"

    (bareMetalGuard "disko-config")
    (bareMetalGuard "kernel")
    (bareMetalGuard "nh")
    (bareMetalGuard "extra-packages")
    (bareMetalGuard "system-sleep")

    hostHardware
    nvidia
    nixosHardware
    (hardwareGuard "tlp")
    (hardwareGuard "bluetooth")
    (hardwareGuard "wifi")

    # Features
    (featureGuard "adguard")
    (featureGuard "auto-upgrade")
    (featureGuard "gaming")
    (featureGuard "jellyfin")
    (featureGuard "silo")
    (featureGuard "libvirtd")
    (featureGuard "openssh")
    (featureGuard "podman")
    (featureGuard "virtualbox")
    swapGuard
    (featureGuard "kanata")
    (featureGuard "liquidctl")
    (featureGuard "thinkfan")
    (featureGuard "wol")
    (featureGuard "remote-unlock")
    microvmGuard
    (microVMGuard "impermanence")
    (featureGuard "ollama")
    (featureGuard "colibri")
  ];

  homeDefaults = [
    hostProfile
    "dex-dotfiles"
    "dex-persist"
    "home-manager"
    "shell-tools"
    "git"
    "fish"
    "bat"
    "fzf"
    "mise"
    "atuin"
    "btop"
    "starship"
    "fastfetch"
    "eza"
    "yazi"
    "devenv"
    "tmux"
    "neovim"
    "tealdeer"
    "zoxide"
    "nur"

    # Features
    (microVMGuard "impermanence")
    (microVMGuard "opencode")
    (microVMGuard "pi-coding-agent")
  ];

  guardImports =
    args:
    let
      inherit (args) entries ctx scope;
      defaultGuard = args.defaultGuard or (_: true);
    in
    lib.concatLists (
      map (
        entry:
        let
          mods =
            if builtins.isString entry then
              { ${entry} = [ (defaultGuard (ctx // { inherit entry; })) ]; }
            else
              entry ctx;
        in
        lib.concatMap (
          modName:
          let
            guards = mods.${modName};
          in
          lib.optional (builtins.all (guard: guard) guards) scope.${modName}
        ) (builtins.attrNames mods)
      ) entries
    );
in
{

  flake.modules.nixos.entrypoint =
    ctx@{ host, ... }:
    {
      imports =
        guardImports {
          entries = nixosDefaults;
          scope = self.modules.nixos;
          ctx = {
            inherit (ctx) inputs;
            inherit (ctx) host hardware features;
          };
        }
        ++ map (module: self.modules.nixos."${module}") host.modules;
    };

  flake.modules.homeManager.entrypoint = ctx: {
    imports = guardImports {
      entries = homeDefaults;
      scope = self.modules.homeManager;
      ctx = { inherit (ctx) hardware host; };
    };
  };
}
