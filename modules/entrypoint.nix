{ self, lib, ... }:
let
  bareMetalGuard = entry: { hardware, ... }: { ${entry} = [ hardware.isBareMetal ]; };
  microVMGuard = entry: { hardware, ... }: { ${entry} = [ hardware.isMicroVM ]; };

  isToggled = arg: (arg.enable or arg) == true;
  scopeGuard = scope: entry: (ctx: { ${entry} = [ (isToggled ctx.${scope}.${entry}) ]; });
  hardwareGuard = entry: scopeGuard "hardware" entry;
  featureGuard = entry: scopeGuard "features" entry;
  hostHardware = { host, hardware, ... }: { "${host.name}-hardware" = [ hardware.isBareMetal ]; };
  nvidia = { hardware, ... }: { nvidia = [ hardware.hasNvidia ]; };
  hostProfile = { host, ... }: { "${host.type}-profile" = [ true ]; };

  nixosDefaults = [
    "dex-persist"
    "base-devel"
    "boot"
    "fish"
    hostProfile
    "like-nix"
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

    (bareMetalGuard "disko-config")
    (bareMetalGuard "kernel")
    (bareMetalGuard "nh")
    (bareMetalGuard "pkgs")
    (bareMetalGuard "system-sleep")

    hostHardware
    nvidia
    (hardwareGuard "nixos-hardware")
    (hardwareGuard "tlp")
    (hardwareGuard "bluetooth")
    (hardwareGuard "wifi")

    # Features
    (featureGuard "adguard")
    (featureGuard "auto-upgrade")
    (featureGuard "gaming")
    (featureGuard "jellyfin")
    (featureGuard "libvirtd")
    (featureGuard "openssh")
    (featureGuard "podman")
    (featureGuard "virtualbox")
    (featureGuard "zram-swap")
    (featureGuard "zswap")
    (featureGuard "kanata")
    (featureGuard "wol")
    (featureGuard "remote-unlock")
    (featureGuard "microvm")
    (microVMGuard "impermanence")
  ];

  homeDefaults = [
    hostProfile
    "dex-dotfiles"
    "dex-persist"
    "home"
    "pkgs-shell"
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
