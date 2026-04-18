{ _, ... }:
{
  flake.modules.nixos.services-openssh =
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
