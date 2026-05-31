{ _, ... }:
{
  flake-file.inputs = {
    solaar.url = "github:Svenum/Solaar-Flake";
    solaar.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.solaar =
    { inputs, ... }:
    {
      imports = [
        inputs.solaar.nixosModules.default
      ];

      services.solaar.enable = true;
    };

  flake.modules.homeManager.solaar =
    { inputs, ... }:
    {
      programs.git.settings.filter = {
        "ignore_solaar_cookie_key" = {
          clean = "sed '/_config_cookie:/d'";
        };
      };
    };
}
