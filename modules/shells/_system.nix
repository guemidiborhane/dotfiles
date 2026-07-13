ctx@{
  lib,
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.mkShell {
  name = "nixos-manager";

  packages = with pkgs; [
    # Version control
    git
    git-lfs

    # Task runner
    just

    # Terminal
    tmux

    # System tools
    parted
    cryptsetup
    lvm2

    # Network
    curl
    wget

    # Text processing
    jq
    yq-go

    # Monitoring
    btop

    # Nix tools
    nix-tree
    nix-du

    # Editor
    neovim
  ];

  shellHook = ''
    echo "╔════════════════════════════════════════╗"
    echo "║     NixOS Configuration Environment    ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    echo "Repository: ${ctx.metadata.repository}"
    echo ""
    echo "Configured hosts:"
    ${builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: host: ''echo "  • ${name} (${host.config.type}) - ${host.config.description}"''
      ) ctx.hosts
    )}
    echo ""
    echo "Quick commands:"
    echo "  just                     Show all commands"
    echo "  just install <host>      Install a host"
    echo "  just add-host <name>     Add new host"
    echo ""
  '';
}
