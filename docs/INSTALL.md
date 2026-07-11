# ACQUIRING THE CONTAGION

Before you can do anything—even before you realize this was a mistake—you must pull the code onto a machine capable of processing your poor decisions. Usually, this is done from a NixOS Installation Media environment.

```bash
git clone https://github.com/guemidiborhane/dotfiles.git hysteria
cd hysteria
```

# THE SURVIVAL KIT: THE SHELL

Once the code is local, you need the specialized tools of the trade. I have packaged these into a development shell so you don't have to pollute your current environment with my dependencies.

To enter the ritual circle, run:

```bash
nix-shell
# or, if you have embraced the flake heresy:
nix develop
```

Upon entry, you will be greeted by a terminal header that looks far more professional than this project deserves. The shell provides:

* **Task Runner**: `just` (the only thing keeping this repo from collapsing).
* **Text Processing**: `jq`, `yq-go` (to parse the TOML/JSON/YAML soup).
* **System Tools**: `parted`, `cryptsetup`, `lvm2` (the scalpel for your hard drive).
* **Monitoring**: `btop` (to watch your CPU thermal throttle during a rebuild).

# EXPANDING THE INFECTION: NEW HOSTS

If one bricked machine isn't enough for you, follow these steps to spread the plague.

## 1. Registration

You must inform the `modules/config/hosts.toml` file of its new victim.

```bash
just add-host <hostname> <type>
```

The `<type>` must be one of: `workstation`, `laptop`, or `homeserver`.

## 2. The Partitioning Ritual

Before installing, ensure the `disk` variable in `modules/config/hosts.toml` matches your target drive (e.g., `/dev/nvme0n1`). If you point it at the wrong drive, `disko` will wipe your family photos with clinical efficiency and zero remorse.

# INSTALLATION: THE DEATH WISH

If you are installing a host (like `kamui`) from the NixOS ISO:

1. **Summon the Environment**:
Ensure you are inside the `nix-shell` or `nix develop` environment created earlier.
2. **Generate the Flake**:
Because we've abstracted the abstraction, you must explicitly generate the Nix configuration.

```bash
just flake
```

1. **Execute the Butcher**:

```bash
just install <hostname>
```

# AFTER-BUTCHER ACTIONS: THE FINAL SACRIFICE

Once the installer has finished carving its path through your hard drive, you are left with a system that has a root password but a completely helpless user account. You must perform the final ritual to grant yourself access before rebooting.

1. **Enter the Corpse**:
Shift your consciousness into the newly installed system residing on `/mnt`.

```bash
sudo nixos-enter
```

1. **Grant the User a Voice**:
The root password was set during the install, but your primary user is currently locked out. Set the user password now. If you have forgotten who you are, the `just` helper can remind you.

```bash
# Outside the chroot, you could find the name,
# but inside you just need to remember your name from modules/config/users.toml:
passwd <your-username>
```

1. **Sever the Connection**:
Leave the chroot and initiate the final collapse.

```bash
exit
reboot
```
