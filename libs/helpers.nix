{ pkgs, cfg, ... }:
let
  inherit (cfg) host;
in {
  base64 = {
    decode = encodedStr: let
      outFile = pkgs.runCommand "decode-base64" {} "echo '${encodedStr}' | base64 --decode > $out";
    in
      builtins.readFile outFile;

    encode = encodedStr: let
      outFile = pkgs.runCommand "decode-base64" {} "echo '${encodedStr}' | base64 > $out";
    in
      builtins.readFile outFile;
  };

  enabled = { enable = true; };

  isLaptop = host.type == "laptop";
  isDesktop = host.type == "desktop";
  isHeadless = host.type == "headless";

  hasAMD = host.cpu == "amd";
  hasIntel = host.cpu == "intel";
  hasNvidia = host.gpu == "nvidia";
  hasAMDGPU = host.gpu == "amd";
}
