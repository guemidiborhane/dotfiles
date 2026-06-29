{ _, ... }:
{
  flake.modules.nixos.security =
    { _, ... }:
    {
      programs.gnupg.agent.enable = true;
      security = {
        polkit.enable = true;
        sudo = {
          extraConfig = ''
            Defaults passwd_timeout=5
            Defaults insults
          '';
        };
      };
    };
}
