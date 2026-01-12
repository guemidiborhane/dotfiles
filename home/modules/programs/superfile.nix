{ config, ... }: {
  enable = true;
  # package = pkgs.unstable.superfile;
  pinnedFolders = [
    {
      name = "Code";
      location = "${config.home.homeDirectory}/Code";
    }
  ];
}
