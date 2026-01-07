{
  pkgs,
  meta,
  ...
}: {
  enableNixpkgsReleaseCheck = true;
  username = "${meta.username}";
  homeDirectory = "/home/${meta.username}";

  packages = import ./pkgs.nix { inherit pkgs; };

  stateVersion = "25.11";
}
