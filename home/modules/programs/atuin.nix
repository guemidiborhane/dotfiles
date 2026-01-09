{ ... }: {
  enable = true;
  settings = {
    sync_address = "https://atuin.netsys.dz";
    update_check = false;
    enter_accept = true;
    style = "compact";
    inline_height = 20;
    history_filter = [
      "^mcli alias set"
      "^echo .* base64 -d"
    ];
  };
  daemon = {
    enable = true;
  };
}
