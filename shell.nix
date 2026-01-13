{pkgs ? import <nixpkgs> {}}:
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

  shellHook = let
    config = builtins.fromTOML (builtins.readFile ./config.toml);
    hosts = builtins.attrValues (builtins.mapAttrs (name: hostConfig: hostConfig // {inherit name;}) config.hosts);
  in ''
    echo "╔════════════════════════════════════════╗"
    echo "║     NixOS Configuration Environment    ║"
    echo "╚════════════════════════════════════════╝"
    echo ""
    echo "User: ${config.user.fullName} (${config.user.username})"
    echo "Repository: ${config.metadata.repository}"
    echo ""
    echo "Configured hosts:"
    ${builtins.concatStringsSep "\n" (map (host: ''echo "  • ${host.name} (${host.type}) - ${host.description}"'') hosts)}
    echo ""
    echo "Quick commands:"
    echo "  just                     Show all commands"
    echo "  just install <host>      Install a host"
    echo "  just add-host <name>     Add new host"
    echo ""
  '';
}
