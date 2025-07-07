# Configuring bluetooth
{pkgs, ...}: {
  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable bluetooth controller service
  services.blueman.enable = true;

  # Wireplumber configuration
  services.pipewire.wireplumber = {
    extraConfig = {
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
      # Kill headset profile, do it multiple times for good measure
      "monitor.bluez.properties" = {
        "bluez5.roles" = [
          "a2dp_sink"
          "a2dp_source"
        ];
      };
      "bluetoothEnhancements" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [
          "a2dp_sink"
          "a2dp_source"
        ];
      };
    };

    # Example headset specific mod
    configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-sonybuds.conf" ''
        wh-1000xm3-ldac-hq = {
          monitor.bluez.rules = [
            {
              matches = [
                device.name = ~bluez_card.*
                device.product.id = 0x0cd3
                device.vendor.id = usb:054c
              ]
              actions = {
                update-props = {
                  bluez5.a2dp.ldac.quality = hq
                }
              }
            }
          ]
        }
      '')
    ];
  };
}
