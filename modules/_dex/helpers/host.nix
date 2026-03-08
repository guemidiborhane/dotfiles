{ ctx, ... }:
let
  inherit (ctx) host hardware users;
in
{
  isLaptop = host.type == "laptop";
  isDesktop = host.type == "desktop";
  isHeadless = host.type == "headless";

  hasAMD = hardware.cpu == "amd";
  hasIntel = hardware.cpu == "intel";
  hasNvidia = hardware.gpu == "nvidia";
  hasAMDGPU = hardware.gpu == "amd";

  forEachUser = fn: builtins.mapAttrs fn users;
}
