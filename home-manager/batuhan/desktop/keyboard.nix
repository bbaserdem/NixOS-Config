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

  stylix.targets.fcitx5 = {
    enable = true;
    colors.enable = true;
    fonts.enable = true;
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        kdePackages.fcitx5-qt
        libsForQt5.fcitx5-qt
        fcitx5-gtk
      ];
      quickPhrase = {
        # Emojis
        ":evilsmirk:" = "😈";
      };
      settings.addons = {
        quickphrase = {
          globalSection = {
            "Choose Modifier" = "None";
            Spell = true;
            FallbackSpellLanguage = "en";
          };
          sections = {
            TriggerKey = {
              "0" = "Control+period";
              "1" = "Super+grave";
            };
          };
        };
      };
    };
  };
  home.packages = with pkgs; [
    kdePackages.fcitx5-qt
    libsForQt5.fcitx5-qt
    fcitx5-gtk
  ];

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
