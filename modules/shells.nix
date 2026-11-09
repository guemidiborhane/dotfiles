{ self, ... }:
let
  inherit (self.dex) metadata hosts;
in
{
  perSystem =
    { pkgs, lib, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixos-manager";

        packages = with pkgs; [
          git
          git-lfs
          just
          tmux
          parted
          cryptsetup
          lvm2
          curl
          wget
          jq
          yq-go
          btop
          nix-tree
          nix-du
          neovim
        ];

        shellHook = ''
          echo "╔════════════════════════════════════════╗"
          echo "║     NixOS Configuration Environment    ║"
          echo "╚════════════════════════════════════════╝"
          echo ""
          echo "Repository: ${metadata.repository}"
          echo ""
          echo "Configured hosts:"
          ${builtins.concatStringsSep "\n" (
            lib.mapAttrsToList (
              name: host: ''echo "  • ${name} (${host.config.type}) - ${host.config.description}"''
            ) hosts
          )}
          echo ""
          echo "Quick commands:"
          echo "  just                     Show all commands"
          echo "  just install <host>      Install a host"
          echo "  just add-host <name>     Add new host"
          echo ""
        '';
      };
    };
}
