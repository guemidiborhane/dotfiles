# HARDWARE: THE FLEET

The current victims of this configuration span multiple machines, each burdened with the weight of my digital neuroses.

## takotsubo - Dell Latitude 7490
**Status:** Primary mobile unit
**Codename:** takotsubo (Broken Heart Syndrome)

The original sufferer. A Dell Latitude 7490 that I have burdened with Hyprland and enough Wayland abstractions to make its integrated Intel GPU scream for mercy. This machine has seen things. It knows what I've done.

**Specifications:**
- **CPU:** Intel Core i7-8650U (Kaby Lake Refresh, 4C/8T)
- **RAM:** 16GB DDR4
- **GPU:** Intel UHD Graphics 620 (thermally distressed)
- **Storage:** SATA SSD
- **Role:** Daily driver when I pretend to be mobile

## kamui - Lenovo ThinkPad P14s Gen 5 AMD
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

## koto - Custom Workstation (5950X)
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
