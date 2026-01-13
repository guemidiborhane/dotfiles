{ pkgs, meta, ... }:
{
  enable = (meta.host.type != "headless");
  package = pkgs.unstable.zed-editor;
  extraPackages = with pkgs; [ nixd ];
}
