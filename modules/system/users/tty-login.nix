{ _, ... }:
{
  flake.modules.nixos.users-tty-login =
    ctx@{ pkgs, lib, ... }:
    {
      systemd.services."getty@tty1" =
        let
          inherit (ctx) config;

          username = ctx.host.defaultUser;
          userExists = builtins.hasAttr username ctx.users;
        in
        lib.mkIf (username != null && userExists) {
          overrideStrategy = "asDropin";
          serviceConfig.ExecStart = [
            "" # override upstream default with an empty ExecStart
            "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} -no ${username} --noclear %I $TERM"
          ];
        };
    };
}
