{ self, ... }:
{
  flake.modules.nixos.users =
    {
      inputs,
      pkgs,
      lib,
      users,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        users-home-manager
        users-tty-login
      ];

      users.groups = users.forEach (
        username: user: {
          gid = user.id;
          members = [ username ];
        }
      );

      users.users = users.forEach (
        username: user: {
          uid = user.id;
          name = username;
          group = username;
          isNormalUser = true;
          description = user.name;
          extraGroups = [
            "networkmanager"
            "wheel"
          ]
          ++ (user.extraGroups or [ ]);
          shell = lib.mkIf (user.shell or null != null) pkgs.unstable.${user.shell};
          homeMode = "0700";
          openssh.authorizedKeys.keys = user.authorizedKeys or [ ];
        }
      );
    };
}
