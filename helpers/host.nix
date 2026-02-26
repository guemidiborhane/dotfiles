{ ctx, ... }:
let
  inherit (ctx) host users;
in
{
  isLaptop = host.type == "laptop";
  isDesktop = host.type == "desktop";
  isHeadless = host.type == "headless";

  hasAMD = host.cpu == "amd";
  hasIntel = host.cpu == "intel";
  hasNvidia = host.gpu == "nvidia";
  hasAMDGPU = host.gpu == "amd";

  forEachUser = fn: builtins.mapAttrs fn users;
}
