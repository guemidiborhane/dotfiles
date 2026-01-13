# DEPRESSINGLY REPRODUCIBLE HYSTERIA

Welcome to the digital manifestation of my obsessive-compulsive disorder. This is not just a NixOS configuration; it is a monument to the hundreds of hours I will never get back, spent ensuring that my terminal padding is consistent across hardware I barely use.

If you are looking for a sane, standard Nix setup, please leave. This repository is a fragile house of cards built on top of a TOML file, held together by the sheer force of my denial and a Justfile.

## THE ARCHITECTURE OF MADNESS

Most people use Nix to manage their system. I use a TOML file to manage Nix, which in turn manages my system. It is an abstraction layer designed to protect my remaining three brain cells from having to look at actual Nix syntax more than once a quarter.

### The Single Source of Truth (The Lie)

All system parameters are funneled through `config.toml`. It defines the user, the theme (Dracula, because I haven't seen sunlight since 2022), and the hosts. It is the steering wheel of a ship that is already halfway underwater.

### The Necronomicon (Justfile)

I have automated my descent into insanity with `just`.

* **install**: A one-way ticket to data loss using disko.
* **rebuild-safe**: A command that checks if Nix is about to compile the entire Linux kernel because I changed a font size. If it sees more than 10 packages, it panics and stops.
* **add-host**: Because I am delusional enough to believe I will one day own more than one functional computer.

## HARDWARE: PROJECT TAKOTSUBO

The current primary victim of this configuration is a Dell Latitude 7490, codenamed **takotsubo**. For the uninitiated, Takotsubo is a medical condition also known as "broken heart syndrome." This is an intentional choice. The laptop is an Intel-based relic that I have burdened with Hyprland and enough Wayland abstractions to make its integrated GPU scream for mercy.

## SOFTWARE STACK

* **Window Manager**: Hyprland. Because why use a stable desktop when you can have windows that slide around like they are on ice?
* **Shell**: Fish. I gave up on POSIX compliance years ago. I prefer the shiny colors.
* **Browser**: Zen Browser. I chose it because the name implies a calm I will never actually achieve.
* **The Tools**: A collection of CLI utilities (atuin, zoxide, fzf) designed to make me feel fast while I spend four hours debugging why my wallpaper didn't load.

## ACQUIRING THE CONTAGION

Before you can do anything—even before you realize this was a mistake—you must pull the code onto a machine capable of processing your poor decisions. Usually, this is done from a NixOS Installation Media environment.

```bash
git clone https://github.com/guemidiborhane/nix-config.git hysteria
cd hysteria

```

## THE SURVIVAL KIT: THE SHELL

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

## EXPANDING THE INFECTION: NEW HOSTS

If one bricked machine isn't enough for you, follow these steps to spread the plague.

### 1. Registration

You must inform the `config.toml` file of its new victim.

```bash
just add-host <hostname> <type>

```

The `<type>` must be one of: `workstation`, `laptop`, or `homeserver`.

### 2. The Partitioning Ritual

Before installing, ensure the `disk` variable in `config.toml` matches your target drive (e.g., `/dev/nvme0n1`). If you point it at the wrong drive, `disko` will wipe your family photos with clinical efficiency and zero remorse.

## INSTALLATION: THE DEATH WISH

If you are installing a host (like `takotsubo`) from the NixOS ISO:

1. **Summon the Environment**:
Ensure you are inside the `nix-shell` or `nix develop` environment created earlier.
2. **Execute the Butcher**:

```bash
just install <hostname>

```

## AFTER-BUTCHER ACTIONS: THE FINAL SACRIFICE

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
# but inside you just need to remember your name from config.toml:
passwd <your-username>

```

1. **Sever the Connection**:
Leave the chroot and initiate the final collapse.

```bash
exit
reboot

```

## MAINTENANCE

If the system fails to boot, do not open an issue. I am likely in a dark room trying to remember what sunlight feels like. The configuration is provided as-is, with no warranty, no support, and no hope.
