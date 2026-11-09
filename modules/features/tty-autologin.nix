_: {
  # `host.defaultUser` selects the tty1 autologin user below; it must resolve to
  # a user the host actually gets (own `users` block plus inherited defaults),
  # so the check lives here beside its only consumer per the colocation rule.
  flake.dex.rules = [
    (
      { config, users, ... }:
      let
        defaultUser = config.defaultUser or null;
        effective = builtins.filter (n: n != "forEach") (builtins.attrNames users);
      in
      if defaultUser != null && defaultUser != "" && !(builtins.elem defaultUser effective) then
        [
          "defaultUser references unknown \"${defaultUser}\" (not among this host's users: [ ${builtins.concatStringsSep ", " effective} ])."
        ]
      else
        [ ]
    )
  ];

  flake.modules.nixos.tty-autologin =
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
