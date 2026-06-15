{ _, ... }:
{
  flake.modules.nixos.openssh =
    { _, ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };
    };
}
