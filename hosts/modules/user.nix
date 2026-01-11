{
  pkgs,
  meta,
  ...
}: {
  users.groups.${meta.username}.gid = 1000;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${meta.username} = {
    isNormalUser = true;
    description = "Borhaneddine GUEMIDI";
    uid = 1000;
    group = meta.username;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.unstable.fish;
    homeMode = "0700";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBf7j2Y+EiXT2hmQGljnfUIWLeOOiZ9INuyQWZHwuenN personal"
    ];
  };
}
