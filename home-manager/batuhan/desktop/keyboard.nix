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
      waylandFrontend = true;
      addons = with pkgs; [
        kdePackages.fcitx5-qt
        fcitx5-gtk
      ];
      quickPhrase = {
        # Emojis
        ":evilsmirk:" = "😈";
      };
      settings = {
        # Fcitx5 settings

        # Languages
        inputMethod = {
          GroupOrder = {
            "0" = "English";
            "1" = "Turkish";
          };
          "Groups/0" = {
            Name = "English";
            "Default Layout" = "us-dvorak-alt-intl";
            DefaultIM = "keyboard-us-alt-intl";
          };
          "Groups/0/Items/0".Name = "keyboard-us-dvorak-alt-intl";
          "Groups/0/Items/1".Name = "keyboard-us-alt-intl";
          "Groups/1" = {
            Name = "Turkish";
            "Default Layout" = "tr-f";
            DefaultIM = "keyboard-tr-intl";
          };
          "Groups/1/Items/0".Name = "keyboard-tr-f";
          "Groups/1/Items/1".Name = "keyboard-tr-intl";
        };

        # Shortcuts;
        # Super + ` : Switches layout
        # Ctrl + Super + ` : Switches language
        globalOptions = {
          Hotkey = {
            ModifierOnlyKeyTimeout = 250;
            "Hotkey/TriggerKeys"."0" = "Control+Super+space";
            "Hotkey/EnumerateForwardKeys"."0" = "Super+grave";
            "Hotkey/EnumerateBackwardKeys"."0" = "Super+asciitilde";
            "Hotkey/EnumerateGroupForwardKeys"."0" = "Control+Super+grave";
            "Hotkey/EnumerateGroupBackwardKeys"."0" = "Control+Super+asciitilde";
            # Switching logic
            EnumerateWithTriggerKeys = false;
            EnumerateSkipFirst = false;
            Behavior = {
              # State management
              resetStateWhenFocusIn = "No";
              ShareInputState = "No";
              PreeditEnabledByDefault = false;
              # Visibility
              ShowInputMethodInformation = true;
              CompactInputMethodInformation = true;
              ShowFirstInputMethodInformation = true;
              showInputMethodInformationWhenFocusIn = false;
              # Passwords
              AllowInputMethodForPassword = false;
              ShowPreeditForPassword = false;
              # Behavior
              ActiveByDefault = false;
              OverrideXkbOption = true;
              PreloadInputMethod = true;
              AutoSavePeriod = 30;
            };
          };
        };

        # Addons
        addons = {
          # Addons

          # Spelling config; default to using enchant
          # Enchant can use nuspell backend, which is superior in turkish
          spell = {
            sections = {
              ProviderOrder = {
                "0" = "Enchant";
                "1" = "Presage";
                "2" = "Custom";
              };
            };
          };

          # Quickphrase; where emoji is available
          # Ctrl + . opens quickphrase menu, type and space insert emoji
          quickphrase = {
            globalSection = {
              "Choose Modifier" = "None";
              FallbackSpellLanguage = "en";
              Spell = true;
              "Commit Key" = "Return";
              "Choose Key" = "Digit";
            };
            sections = {
              TriggerKey = {
                "0" = "Control+period";
              };
            };
          };

          # Unicode, trigger unicode code entry, or search
          unicode = {
            TriggerKey = {
              "0" = "Control+semicolon";
            };
            DirectUnicodeMode."0" = "Control+Shift+U";
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
