# NOTE: Before using the cache you should rebuild to add it to the config
{ _, ... }:
{
  flake.nixosModules.nix-substituters =
    { h, ... }:
    let
      caches = [
        {
          url = "https://vicinae.cachix.org/";
          key = "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc=";
        }
        {
          url = "https://attic.xuyh0120.win/lantian";
          key = "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=";
        }
        {
          url = "https://nltch.cachix.org";
          key = "nltch.cachix.org-1:W85YxOt0XRZOP3Yppt+HNz3fXRu6DXgH3Ob9n9A+7Ec=";
        }
        {
          url = "https://nix-community.cachix.org";
          key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
        }
        {
          url = "https://hyprland.cachix.org";
          key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
        }
      ];
      urls = h.pluck "url" caches;
      keys = h.pluck "key" caches;
    in
    {
      nix.settings = {
        extra-substituters = urls;
        extra-trusted-substituters = urls;
        extra-trusted-public-keys = keys;
      };
    };
}
