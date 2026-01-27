{ pkgs, meta, cfg, config, ... }:
{
  users.groups.${cfg.user.username}.gid = 1000;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${cfg.user.username} = {
    isNormalUser = true;
    description = cfg.user.fullName;
    uid = 1000;
    group = cfg.user.username;
    extraGroups = [ "networkmanager" "wheel" "uinput" ];
    shell = pkgs.unstable.${cfg.user.shell};
    homeMode = "0700";
    openssh.authorizedKeys.keys = cfg.user.sshKeys;
  };
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      "" # override upstream default with an empty ExecStart
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} -no ${cfg.user.username} --noclear %I $TERM"
    ];
  };
}
