# Wireplumber rules to disable headset mode
{
  config,
  pkgs,
  ...
}: let
  cHome = config.xdg.configHome;
  fName = "${cHome}/wireplumber/bluetooth.lua.d/10-disable-hsp.lua";

  # Replace with your device MAC addresses
  disabledHspDevices = [
    # Albastı: My bluetooth headphones
    "bluez_card.BC_87_FA_48_42_1C"
  ];

  luaScript = ''
    local disabled_devices = ${builtins.toJSON disabledHspDevices}

    for _, device_name in ipairs(disabled_devices) do
      local rule = {
        matches = {
          {
            { "device.name", "matches", device_name },
          },
        },
        apply_properties = {
          ["bluez5.auto-connect"] = "[ a2dp_sink ]",
          ["bluez5.headset-backend"] = "none",
        },
      }

      table.insert(bluez_monitor.rules, rule)
    end
  '';
in {
  home.file.${fname}.text = luaScript;

  # Ensure PipeWire + WirePlumber is set up correctly
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };
}
