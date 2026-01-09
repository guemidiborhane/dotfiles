{ pkgs, ... }: {
  boot.kernelModules = [ "uinput" ];

  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  users.groups.uinput = { };

  systemd.services.kanata-default.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  services.kanata = {
    enable = true;
    keyboards = {
      default = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          "/dev/input/by-path/pci-0000:00:14.0-usb-0:9:1.2-event-mouse"
          "/dev/input/by-path/pci-0000:00:14.0-usbv2-0:9:1.2-event-mouse"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defvar
            tap-time 150
            hold-time 200

            met lmet
            ctl lctl
            alt lalt
            sft lsft
          )

          (defsrc
            caps
            a s d f
            j k l ;
            g h
            f10 f11 f12
            lmet rmet
            lsft rsft
            lctl rctl 
            lalt ralt
            spc
            mousebackward mouseforward
          )

          (deflayer base
            esc
            @a @s @d @f
            @j @k @l @;
            _ _
            mute voldwn volu
            ✗ ✗
            ✗ ✗
            M-7 ✗
            M-g ✗
            @spc
            pp next
          )

          (deflayermap secondary
            a M-9
            s M-2
            d M-1
            f bspc

            h left
            j down
            k up
            l right
          )

          (defalias
            a (tap-hold $tap-time $hold-time a $alt)
            s (tap-hold $tap-time $hold-time s $sft)
            d (tap-hold $tap-time $hold-time d $met)
            f (tap-hold $tap-time $hold-time f $ctl)

            j (tap-hold $tap-time $hold-time j $ctl)
            k (tap-hold $tap-time $hold-time k $met)
            l (tap-hold $tap-time $hold-time l $sft)
            ; (tap-hold $tap-time $hold-time ; $alt)

            spc (tap-hold $tap-time $hold-time spc (layer-while-held secondary))
          )
        '';
      };
    };
  };
}
