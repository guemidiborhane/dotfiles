{ self, ... }: {
  flake.modules.homeManager.pi-coding-agent =
    { user, ... }:
    {
      imports = [ self.modules.homeManager.omniroute ];
      dex.persist.directories = [ ".pi/agent" ];

      programs.pi-coding-agent = {
        enable = user.features.ai.pi-coding-agent or false;
        settings = {
          theme = "system";
          enableInstallTelemetry = false;
          terminal.showTerminalProgress = true;
        };
      };
    };
}
