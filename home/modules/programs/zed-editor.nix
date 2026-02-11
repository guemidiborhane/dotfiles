{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor;
    extraPackages = with pkgs; [ nixd ];
  };
}
