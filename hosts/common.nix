{
  config,
  pkgs,
  inputs,
  meta,
  lib,
  ...
}: {
  imports = [
    ./modules/base-devel.nix
    ./modules/networking.nix
    ./modules/virtualisation.nix
    ./modules/hyprland.nix
    ./modules/kanata.nix
  ];

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];

      extra-substituters = [
        "https://vicinae.cachix.org"
        "https://attic.xuyh0120.win/lantian"
      ];
      extra-trusted-substituters = [
        "https://vicinae.cachix.org"
        "https://attic.xuyh0120.win/lantian"
      ];
      extra-trusted-public-keys = [
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.rtkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults passwd_timeout=5
    Defaults insults
  '';

  # Set your time zone.
  time.timeZone = "Africa/Algiers";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.polkit.enable = true;
  services.udisks2.enable = true;

  services.fstrim.enable = true;

  services.fwupd.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${meta.username} = {
    isNormalUser = true;
    description = "Borhaneddine GUEMIDI";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.unstable.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBf7j2Y+EiXT2hmQGljnfUIWLeOOiZ9INuyQWZHwuenN personal"
    ];
  };

  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     curl
     kitty
     git
     git-lfs
     fastfetch
     ripgrep
     fd
     gcc
     rustup
     lazygit
     libnotify
     bc
     btop
     bandwhich
     lm_sensors
     jq
     config.boot.kernelPackages.cpupower
  ];

  environment.shellAliases.ls = lib.mkForce null;

  fonts.packages = with pkgs; [
     cantarell-fonts
     nerd-fonts.monaspace
     nerd-fonts.jetbrains-mono
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/etc/nixos";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure.customRC = ''
      set number
      set relativenumber
      set cursorline
    '';
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.unstable; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  #
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
