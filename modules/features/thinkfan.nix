_: {
  flake.modules.nixos.thinkfan =
    {
      lib,
      hardware,
      features,
      ...
    }:
    let
      inherit (hardware.fan) band speeds;

      # [type, path, name, indices?] tuples -> thinkfan sensor attrsets.
      # name "" means path-only (tpacpi); omit it so thinkfan matches by query alone.
      sensors = map (
        s:
        let
          name = builtins.elemAt s 2;
        in
        {
          type = builtins.elemAt s 0;
          query = builtins.elemAt s 1;
          indices = if builtins.length s > 3 then builtins.elemAt s 3 else [ 1 ];
        }
        // lib.optionalAttrs (name != "") { inherit name; }
      ) features.thinkfan.sensors;

      curve = speeds;
      lowestTemp = builtins.elemAt (builtins.head curve) 0;
      highestTemp = builtins.elemAt (lib.last curve) 0;

      # Middle levels are derived from the shared [temp, speed] curve as
      # [speed, temp-band, temp+band]. The fan-off floor and full-speed ceiling
      # frame the curve: the floor rides just below the first point and the
      # ceiling caps at thinkfan's sentinel 32767.
      midLevels = map (
        p:
        let
          temp = builtins.elemAt p 0;
          speed = builtins.elemAt p 1;
        in
        [
          speed
          (temp - band)
          (temp + band)
        ]
      ) curve;

      levels = [
        [
          0
          (lowestTemp - band)
          lowestTemp
        ]
      ]
      ++ midLevels
      ++ [
        [
          "level full-speed"
          highestTemp
          32767
        ]
      ];
    in
    {
      services.thinkfan = {
        enable = true;
        inherit sensors levels;

        fans = [
          {
            type = "tpacpi";
            query = "/proc/acpi/ibm/fan";
          }
        ];
      };
    };
}
