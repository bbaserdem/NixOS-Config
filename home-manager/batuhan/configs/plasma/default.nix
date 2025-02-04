# Configuring plasma
{
  pkgs,
  ...
}: {

  # Enable KDE connect
  services.kdeconnect = {
    enable = true;
    indicator = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  # Configure plasma
  programs.plasma = {
    enable = true;
    immutableByDefault = true;
 
    # Desktop settings
    desktop = {
      icons = {
        alignment = "right";
        arrangement = "topToBottom";
        folderPreviewPopups = true;
        lockInPlace = true;
        size = 4;
        sorting = {
          descending = true;
          foldersFirst = true;
          mode = "name";
          mouseActions = {
            rightClick = "contextMenu";
            middleClick = "applicationLauncher";
            leftClick = null;
            verticalScroll = "switchVirtualDesktop";
          };
        };
      };
      #widgets = {};
    };

    # Krunner
    krunner = {
      activateWhenTypingOnDesktop = true;
      historyBehavior = "enableAutoComplete";
      position = "top";
    };

    # Screen lock
    kscreenlocker = {
      appearance = {
        alwaysShowClock = true;
        showMediaControls = true;
        autoLock = false;
        lockOnResume = true;
        lockOnStartup = false;
        passwordRequired = true;
        passwordRequiredDelay = 5;
        timeout = null;
      };
    };

    # Workspace related settings
    workspace = {
      allowWindowsToRememberPositions = false;
      # colorScheme = "Gruvboxdarksoft";
      # lookAndFeel = "stylix";
      splashSchreen.theme = "org.kde.breeze.desktop";
      # theme = "default";
      wallpaperBackground.blur = true;
      windowDecorations = {
        library = org.kde.breeze;
        theme = "Breeze";
      };
    };

    # App settings
    kate = {
      enable = true;
      editor = {
        brackets = {
          automaticallyAddClosing = true;
          flashMatching = true;
          highlightMatching = true;
          highlightRangeBetween = true;
        };
        indent = {
          autodetect = true;
          backspaceDecreaseIndent = true;
          keepExtraSpaces = false;
          replaceWithSpaces = true;
          showLines = true;
          tabFromEverywhere = false;
          undoByShiftTab = true;
          width = 2;
        };
        inputMode = "vi";
        tabWidth = 4;
      };
    };
    okular = {
      enable = true;
      accessibility = {
        changeColors = {
          enable = false;
          mode = "InvertLumaSymmetric";
        };
      };
      general = {
        obeyDrm = false;
        openFileInTabs = true;
        showScrollbars = true;
        smoothScrolling = true;
        viewContinuous = true;
        viewMode = "Facing";
        zoomMode = "fitWidth";
      };
      performance = {
        enableTransparencyEffects = true;
        memoryUsage = "Aggressive";
      };
    };

    # App specific disables
    elisa.enable = false;
    ghostwriter.enable = false;
    konsole.enable = false;

  };

}
