{ _, ... }:
{
  flake.modules.homeManager.programs-atuin =
    { secrets, ... }:
    {
      programs.atuin = {
        enable = true;
        daemon.enable = true;
        flags = [ "--disable-up-arrow" ];
        forceOverwriteSettings = true;
        settings = {
          inherit (secrets.atuin) sync_address;
          update_check = false;
          enter_accept = true;
          style = "compact";
          inline_height = 20;
          history_filter = [
            "^mcli alias set"
            "^echo .* base64 -d"
          ];
        };
      };
    };
}
