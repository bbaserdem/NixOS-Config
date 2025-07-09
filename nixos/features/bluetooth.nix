# Configuring bluetooth
{pkgs, ...}: {
  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Wireplumber configuration
  services.pipewire.wireplumber = {
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
