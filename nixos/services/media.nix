# Do sound outputs
{
  pkgs,
  lib,
  config,
  ...
}: {
  # Using PipeWire as the sound server conflicts with PulseAudio.
  # This option requires `hardware.pulseaudio.enable` to be set to false.
  hardware.pulseaudio.enable = false;
  # Recommended to have rtkit enabled
  security.rtkit.enable = true;
  # Main enabling script
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;

    # Most this config ripped from package search, and the wiki. I don't get it
    wireplumber = {
      enable = true;
      extraConfig = {
        "log-level-debug" = {
          "context.properties" = {
            # Output Debug log messages as opposed to only the default level (Notice)
            "log.level" = "D";
          };
        };
        "wh-1000xm3-ldac-hq" = {
          "monitor.bluez.rules" = [
            {
              matches = [
                {
                  # Match any bluetooth device with ids equal to that of a WH-1000XM3
                  "device.name" = "~bluez_card.*";
                  "device.product.id" = "0x0cd3";
                  "device.vendor.id" = "usb:054c";
                }
              ];
              actions = {
                update-props = {
                  # Set quality to high quality instead of the default of auto
                  "bluez5.a2dp.ldac.quality" = "hq";
                };
              };
            }
          ];
        };
        bluetoothEnhancements = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [
              "hsp_hs"
              "hsp_ag"
              "hfp_hf"
              "hfp_ag"
            ];
          };
        };
      };
    };
  };
}
