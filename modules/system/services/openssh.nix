{ _, ... }:
{
  flake.modules.nixos.openssh =
    { _, ... }:
    {
      dex.persist.files = [ "/etc/ssh/ssh_host_ed25519_key" ];

      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
        };
      };
    };
}
