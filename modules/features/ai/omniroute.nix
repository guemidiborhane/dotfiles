_: {
  # TODO: track main once PR gets merged
  flake-file.inputs.omniroute.url = "github:diegosouzapw/OmniRoute/pull/13076/head";

  flake.modules.homeManager.omniroute =
    { inputs, pkgs, ... }:
    let
      omniroute = inputs.omniroute.packages.${pkgs.stdenv.hostPlatform.system}.omniroute;
    in
    {
      dex.persist.directories = [ ".omniroute" ];
      home.packages = [ omniroute ];
      systemd.user.services.omniroute = {
        Unit = {
          Description = "tmux server daemon";
          Documentation = "man:tmux(1)";
        };

        Service = {
          Type = "simple";
          ExecStart = "${omniroute}/bin/omniroute";
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
}
