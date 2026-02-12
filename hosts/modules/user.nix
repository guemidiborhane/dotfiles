{
  pkgs,
  cfg,
  config,
  lib,
  ...
}:
let
  inherit (cfg) users host;
in
{
  users.groups = builtins.mapAttrs (username: user: {
    gid = user.id;
    members = [ username ];
  }) users;

  users.users = builtins.mapAttrs (username: user: {
    uid = user.id;
    name = username;
    group = username;
    isNormalUser = true;
    description = user.fullName;
    extraGroups = [
      "networkmanager"
      "wheel"
      "uinput"
      "libvirtd"
    ];
    shell = lib.mkIf (user.shell or null != null) pkgs.unstable.${user.shell};
    homeMode = "0700";
    openssh.authorizedKeys.keys = user.sshKeys or [ ];
  }) users;

  systemd.services."getty@tty1" =
    let
      userName = host.defaultUser;
      userExists = builtins.hasAttr userName users;
    in
    lib.mkIf (userName != null && userExists) {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        "" # override upstream default with an empty ExecStart
        "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} -no ${host.defaultUser} --noclear %I $TERM"
      ];
    };
}
