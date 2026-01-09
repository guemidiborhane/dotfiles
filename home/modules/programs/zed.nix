{ pkgs, ... }: {
  enable = true;
  package = pkgs.unstable.zed-editor;
  extraPackages = with pkgs; [ nixd ];
}
