{
  pkgs,
  meta,
  ...
}: {
  enableNixpkgsReleaseCheck = true;
  username = "${meta.username}";
  homeDirectory = "/home/${meta.username}";


  stateVersion = "25.11";
}
