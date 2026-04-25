{ _, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      formatter = pkgs.nixfmt;
    };

  systems = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];
}
