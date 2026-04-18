{ self, ... }:
{
  flake.modules.nixos.users =
    {
      inputs,
      pkgs,
      lib,
      h,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        users-home-manager
        users-tty-login
      ];

      users.groups = h.forEachUser (
        username: user: {
          gid = user.id;
          members = [ username ];
        }
      );

      users.users = h.forEachUser (
        username: user: {
          uid = user.id;
          name = username;
          group = username;
          isNormalUser = true;
          description = user.fullName;
          extraGroups = [
            "networkmanager"
            "wheel"
          ]
          ++ (user.extraGroups or [ ]);
          shell = lib.mkIf (user.shell or null != null) pkgs.unstable.${user.shell};
          homeMode = "0700";
          openssh.authorizedKeys.keys = user.sshKeys or [ ];
        }
      );
    };
}
