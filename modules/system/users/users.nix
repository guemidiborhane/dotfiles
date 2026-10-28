{ self, lib, ... }:
let
  # `user.shell` indexes `pkgs.unstable.${shell}` below; the domain lives here,
  # beside its only consumer, per the colocation rule in modules/dex/dex.nix.
  validShells = [
    "bash"
    "fish"
    "zsh"
  ];
in
{
  flake.dex.rules = [
    # A host's declared `users` keys must reference users that exist in
    # users.toml; this module resolves them into system users below.
    (
      { config, ... }:
      let
        userNames = builtins.attrNames self.tomlConfigs.users;
        declared = builtins.attrNames (config.users or { });
      in
      map (u: "users references unknown \"${u}\".") (
        builtins.filter (u: !(builtins.elem u userNames)) declared
      )
    )
    # `user.shell` must be one of the supported shells.
    (
      { users, ... }:
      lib.concatLists (
        builtins.attrValues (
          users.forEach (
            username: user:
            lib.optional
              (
                (user.shell or null) != null
                && (user.shell or null) != ""
                && !(builtins.elem user.shell validShells)
              )
              "user '${username}': shell must be one of [ ${lib.concatStringsSep ", " validShells} ] (got \"${user.shell}\")."
          )
        )
      )
    )
  ];

  flake.modules.nixos.users =
    {
      pkgs,
      lib,
      users,
      ...
    }:
    {
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
