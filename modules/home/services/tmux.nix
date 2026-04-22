{ _, ... }:
{
  flake.modules.homeManager.services-tmux =
    { pkgs, ... }:
    {
      systemd.user = {
        slices.tmux = {
          Unit.Description = "tmux slice";
        };

        services.tmux = {
          Unit = {
            Description = "tmux server daemon";
            Documentation = "man:tmux(1)";
          };

          Service = {
            Type = "simple";
            ExecStart = "${pkgs.fish}/bin/fish -c 'exec ${pkgs.tmux}/bin/tmux -D'";
            ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
            Slice = "tmux.slice";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };
}
