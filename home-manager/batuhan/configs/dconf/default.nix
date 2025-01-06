# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  lib,
  config,
  ...
}: {
  dconf.settings = {
    # IBUS related options (for emoji and utf input)
    "desktop/ibus/general" = {
      use-system-keyboard-layout = true;
    };
    "desktop/ibus/general/hotkey" = {
      triggers = [];
    };
    "desktop/ibus/panel/emoji" = {
      hotkey = ["<Control>period"];
    };

    # GNOME settings
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/datetime" = {
      automatic-timezone = false;
    };
    # Keyboard layout set here specifically for gnome
    "org/gnome/desktop/input-sources" = {
      mru-sources = [
        (lib.hm.gvariant.mkTuple ["xkb" "us+dvorak-alt-intl"])
        (lib.hm.gvariant.mkTuple ["xkb" "tr+f"])
        (lib.hm.gvariant.mkTuple ["xkb" "us+altgr-intl"])
      ];
      per-window = false;
      show-all-sources = true;
      sources = [
        (lib.hm.gvariant.mkTuple ["xkb" "us+dvorak-alt-intl"])
        (lib.hm.gvariant.mkTuple ["xkb" "tr+f"])
        (lib.hm.gvariant.mkTuple ["xkb" "us+altgr-intl"])
      ];
      xkb-options = [
        "compose:ins"
        "grp:alt_caps_toggle"
      ];
    };
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      cursor-size = 32;
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 5;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      ambient-enabled = false;
      idle-dim = false;
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/system/location" = {
      enabled = true;
    };

    # Input settings
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
  };
}
