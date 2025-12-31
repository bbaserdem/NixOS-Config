# Language and keyboard settings
{
  lib,
  pkgs,
  ...
}: {
  # Home settings
  home = {
    # Set layout
    keyboard = {
      layout = "us,tr,us";
      variant = "dvorak-alt-intl,f,altgr-intl";
      options = ["grp:alt_caps_toggle"];
    };

    # Set locale
    language = {
      base = "en_US.UTF-8";
      collate = "tr_TR.UTF-8";
      name = "tr_TR.UTF-8";
    };
  };

  # Dconf settings
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
  };
}
