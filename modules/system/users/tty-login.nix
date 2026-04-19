{ _, ... }:
{
  flake.modules.nixos.users-tty-login =
    {
      config,
      pkgs,
      host,
      lib,
      users,
      ...
    }:
    {
      systemd.services."getty@tty1" =
        let
          username = host.defaultUser;
          userExists = builtins.hasAttr username users;
        in
        lib.mkIf (username != null && userExists) {
          overrideStrategy = "asDropin";
          serviceConfig.ExecStart = [
            "" # override upstream default with an empty ExecStart
            "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} -no ${username} --noclear %I $TERM"
          ];
        };
      security.pam.services."getty@tty1".enableGnomeKeyring = true;
    };
}
