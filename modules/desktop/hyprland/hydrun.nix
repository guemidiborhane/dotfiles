_: {
  flake.modules.homeManager.hydrun =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      # The package lives in pkgs/hydrun.nix (exposed via self.overlays.packages).
      # Override hyprctl's provider with this host's exact Hyprland build so the
      # dispatch actions match the running compositor.
      hydrun = pkgs.hydrun.override {
        hyprland = config.wayland.windowManager.hyprland.finalPackage;
      };
    in
    {
      home.packages = [ hydrun ];

      programs.fish = {
        shellAliases.dr = lib.getExe hydrun;

        interactiveShellInit = lib.mkAfter /* fish */ ''
          if not functions -q __hydrun_after_doubledash
            ${lib.getExe hydrun} --completion fish | source
          end
        '';
      };
    };
}
