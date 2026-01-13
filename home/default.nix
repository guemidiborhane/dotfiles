{
  cfg,
  pkgs,
  lib,
  inputs,
  meta,
  enabled,
  ...
}: {
  imports =
    [
      ./modules/git.nix
      ./modules/yadm.nix
      ./modules/shell.nix
    ]
    ++ lib.optionals (meta.host.type != "headless") [
      ./modules/zen-browser.nix
      ./modules/desktop
    ];

  home = import ./home.nix { inherit pkgs cfg; };
  services = import ./modules/services { inherit pkgs lib enabled; };

  programs.ghostty = import ./modules/programs/ghostty.nix;
  programs.foot = import ./modules/programs/foot.nix;
  programs.yadm = import ./modules/programs/yadm.nix;
  programs.vicinae = import ./modules/programs/vicinae.nix { inherit pkgs inputs; };
  programs.zed-editor = import ./modules/programs/zed.nix { inherit pkgs meta; };

  programs = {
    home-manager = enabled;
    wezterm = enabled;
    wlogout = enabled;
    mpv = enabled;
  };
}
