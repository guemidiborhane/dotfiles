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
+ **rebuild-safe**: A sarcastic reminder that you should use `nh os test` instead. It will shame you for seeking safety.
+ **check-builds**: See what packages will be rebuilt. No judgment, just facts.
* **add-host**: Because I am delusional enough to believe I will one day own more than one functional computer.

## HARDWARE: THE FLEET

The current victims of this configuration span multiple machines, each burdened with the weight of my digital neuroses.

### takotsubo - Dell Latitude 7490
**Status:** Primary mobile unit
**Codename:** takotsubo (Broken Heart Syndrome)

The original sufferer. A Dell Latitude 7490 that I have burdened with Hyprland and enough Wayland abstractions to make its integrated Intel GPU scream for mercy. This machine has seen things. It knows what I've done.

**Specifications:**
- **CPU:** Intel Core i7-8650U (Kaby Lake Refresh, 4C/8T)
- **RAM:** 16GB DDR4
- **GPU:** Intel UHD Graphics 620 (thermally distressed)
- **Storage:** SATA SSD
- **Role:** Daily driver when I pretend to be mobile

### kamui - Lenovo ThinkPad P14s Gen 5 AMD
**Status:** Home away from home
**Codename:** kamui (Dimensional Jutsu - because it warps between locations)

The mobile workstation. A Lenovo ThinkPad P14s Gen 5 with an AMD Ryzen 7 8840HS that actually has enough power to compile the monstrosity that is this configuration without triggering a thermal event. This is what happens when you decide that 16GB wasn't enough suffering.

**Specifications:**
- **CPU:** AMD Ryzen 7 8840HS (Zen 4, 8C/16T, actually competent)
- **RAM:** 32GB DDR5 (finally, room to breathe)
- **GPU:** AMD Radeon 780M integrated (surprisingly capable)
- **Storage:** 1TB NVMe (because I have trust issues with the cloud)
- **Kernel:** CachyOS x86_64-v4 optimized (because living on the edge makes me feel something)
- **Role:** Mobile workstation, home away from home
- **Special Features:** Fingerprint reader (that I configured), actually decent battery life

### koto - Custom Workstation (5950X)
**Status:** The anchor
**Codename:** kotoamatsukami (Ultimate Genjutsu - because reality bends to its will)
**Location:** The office (where productivity goes to die)

The main event. A custom-built AMD Ryzen 9 5950X workstation with 64GB of RAM and an NVIDIA RTX 3060 Ti. The GPU is an 8GB LHR model because I didn't know better back then, but CUDA is still king for playing with LLMs locally, so it stays. This machine doesn't ask questions. It doesn't judge. It just compiles, renders, and occasionally runs inference on models that are definitely too large for 8GB of VRAM.

**Specifications:**
- **CPU:** AMD Ryzen 9 5950X (16C/32T of raw power)
- **RAM:** 64GB DDR4 (because 32GB is for the weak)
- **GPU:** NVIDIA GeForce RTX 3060 Ti 8GB LHR (CUDA enabled, VRAM limited)
- **Storage:** 1TB NVMe primary + multiple secondary drives mounted to `/mnt/*`
- **Kernel:** CachyOS x86_64-v3 optimized (because stock is for cowards)
- **Role:** Primary workstation, build server, LLM playground, occasional space heater
- **Special Features:**
  - Wake-on-LAN enabled (enp6s0)
  - Remote LUKS unlock via initrd SSH
  - Custom Netbird port (51281) because default ports are for people without port conflicts
  - Auto-updates enabled (living dangerously)
  - CoolerControl for fan management (the 5950X runs hot)

### The Network
All three machines are connected via **Netbird** mesh VPN. Netbird is genuinely excellent software - WireGuard-based, self-hostable, and it just works. The mesh topology means `takotsubo` can reach `koto` from a coffee shop without exposing SSH to the internet, and `kamui` seamlessly integrates whether it's at home or traveling. All traffic stays encrypted, all hosts are accessible by hostname, and I never have to think about it.

The control plane runs on my own infrastructure because trusting cloud providers is for people who don't read privacy policies.

### Common Suffering
All machines share:
- **OS:** NixOS (the only acceptable Linux distribution)
- **Keyboard:** Kanata with home row mods (my wrists will thank me eventually)
- **Despair:** Uniformly distributed across all hardware

Each machine has a `hardware-configuration.nix` that was generated once and will never be touched again unless something catastrophically breaks.

## SOFTWARE STACK

* **Window Manager**: Hyprland. Because why use a stable desktop when you can have windows that slide around like they are on ice?
* **Theme:** Dracula (because I haven't seen sunlight since 2022)
* **Shell**: Fish. I gave up on POSIX compliance years ago. I prefer the shiny colors.
* **Browser**: Zen Browser. I chose it because the name implies a calm I will never actually achieve.
* **Dotfiles:** Managed via YADM, auto-cloned on first boot
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
