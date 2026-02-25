ctx@{
  inputs,
  users,
  h,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    backupCommand = "trash";

    extraSpecialArgs = h.mkHomeContext ctx pkgs;

    users = builtins.mapAttrs (username: user: {
      _module.args = { inherit user; };
      imports = ctx.homeModules;
    }) users;
  };
}
