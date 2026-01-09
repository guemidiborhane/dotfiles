{ ... }: {
  enable = true;
  settings = {
    idiomatic_version_file_enable_tools = ["ruby"];
    experimental = true;
  };
  globalConfig = {
    plugins = {
      nix = "https://github.com/jbadeau/mise-nix.git";
    };
    tools = {
      go = "latest";
      krew = "latest";
      kubectl = "latest";
      kubectx = "latest";
      kubens = "latest";
      "nix:yarn" = "latest";
      "nix:php" = "latest";
      "nix:ruby" = "3";
      "nix:nodejs" = "24";
      bun = "latest";
      usage = "latest";
    };
  };
}
