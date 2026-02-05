{ pkgs, cfg, config, ... }:
{
  users.groups.${cfg.user.username}.gid = 1000;
  users.users.${cfg.user.username} = {
    uid = 1000;
    isNormalUser = true;
    description = cfg.user.fullName;
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
