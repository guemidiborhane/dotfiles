{ _, ... }:
{
  flake.modules.homeManager.pi-coding-agent =
    { lib, user, ... }:
    lib.mkIf (user.features.ai.pi-coding-agent or false) {
      dex.persist.directories = [ ".pi/agent" ];

      programs.pi-coding-agent = {
        enable = true;
        settings = {
          theme = "system";
          enableInstallTelemetry = false;
          terminal.showTerminalProgress = true;
        };
      };
    };
}
