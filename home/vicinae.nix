{
    pkgs,
    inputs,
    ...
}: {
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae.package = inputs.vicinae.packages.${pkgs.system}.default;
  services.vicinae.enable = true;

  services.vicinae.systemd = {
    enable = true;
    autoStart = true;
    environment = {
      USE_LAYER_SHELL = 1;
    };
  };
}
