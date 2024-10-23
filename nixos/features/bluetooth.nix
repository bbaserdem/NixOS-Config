# Configuring bluetooth
{
  config,
  pkgs,
  lib,
  ...
}: {
  services.blueman.enable = true;
  # Disable HSP/HSF mode
  services.pipewire.wireplumber.extraConfig = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
    "monitor.bluez.properties" = {
      "bluez5.roles" = ["a2dp_sink" "a2dp_source"];
    };
  };
}
