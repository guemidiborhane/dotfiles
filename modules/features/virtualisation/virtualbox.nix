{ _, ... }:
{
  flake.modules.nixos.virtualbox =
    { ... }:
    {

      virtualisation.virtualbox.host = {
        enable = true;
      };
    };
}
