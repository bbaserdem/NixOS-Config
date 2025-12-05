# Configuring gnome extensions if wanted
{
  pkgs,
  lib,
  ...
}: {
  # Enable stylix themeing
  stylix.targets = {
    gnome.enable = true;
    # In unstable
    #gnome-text-editor.enable = true;
  };

  # Some gnome extensions
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      # Status tray
      {package = appindicator;}
      # Battery of wireless devices shown
      {package = wireless-hid;}
      # Menu for removable drives
      {package = removable-drive-menu;}
      # Shows system resources
      {package = system-monitor;}
      # Clipboard
      {package = clipboard-indicator;}
    ];
  };
  #
  # # Configure through dconf
  # dconf.settings = {
  #   # Background style
  #   "org/gnome/desktop/background" = {
  #     color-shading-type = "solid";
  #     primary-color = "#000000000000";
  #     secondary-color = "#000000000000";
  #   };
  #
  #   # Workspace number
  #   "org/gnome/desktop/wm/preferences" = {
  #     num-workspaces = 5;
  #   };
  #   "org/gnome/desktop/calendar" = {
  #     show-weekdate = true;
  #   };
  #   "org/gnome/desktop/datetime" = {
  #     automatic-timezone = false;
  #   };
  #   "org/gnome/desktop/interface" = {
  #     clock-show-seconds = true;
  #     clock-show-weekday = true;
  #     #color-scheme = "prefer-dark";
  #     cursor-size = 32;
  #     show-battery-percentage = true;
  #     toolkit-accessibility = false;
  #   };
  #   "org/gnome/settings-daemon/plugins/color" = {
  #     night-light-enabled = true;
  #   };
  #   "org/gnome/settings-daemon/plugins/power" = {
  #     ambient-enabled = false;
  #     idle-dim = false;
  #     sleep-inactive-ac-type = "nothing";
  #   };
  #   "org/gnome/system/location" = {
  #     enabled = true;
  #   };
  #
  #   # Input settings
  #   "org/gnome/desktop/peripherals/touchpad" = {
  #     tap-to-click = true;
  #     two-finger-scrolling-enabled = true;
  #   };
  #
  #   # Shell settings
  #   "org/gnome/shell" = {
  #     disable-user-extensions = false;
  #     # Enabling extensions
  #     enabled-extensions = [
  #       "appindicatorsupport@rgcjonas.gmail.com"
  #       "wireless-hid@chlumskyvaclav.gmail.com"
  #       "drive-menu@gnome-shell-extensions.gcampax.github.com"
  #       "system-monitor@gnome-shell-extensions.gcampax.github.com"
  #       "clipboard-indicator@tudmotu.com"
  #       "user-theme@gnome-shell-extensions.gcampax.github.com"
  #       "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
  #     ];
  #     # Pinned to dash
  #     favorite-apps = [
  #       "firefox.desktop"
  #       "org.gnome.Nautilus.desktop"
  #       "kitty.desktop"
  #       "zotero.desktop"
  #       "Zoom.desktop"
  #       "virt-manager.desktop"
  #       "cantata.desktop"
  #       "ferdium.desktop"
  #       "signal-desktop.desktop"
  #       "obsidian.desktop"
  #       "calibre-gui.desktop"
  #     ];
  #     remember-mount-password = false;
  #   };
  #
  #   # Extensions settings
  #   "org/gnome/tweaks" = {
  #     show-extensions-notice = false;
  #   };
  #   "org/gnome/shell/extensions/clipboard-indicator" = {
  #     cache-only-favorites = true;
  #     clear-on-boot = true;
  #     confirm-clear = true;
  #     history-size = 5;
  #   };
  #   "org/gnome/shell/extensions/system-monitor" = {
  #     show-download = true;
  #     show-swap = false;
  #     show-upload = true;
  #   };
  #   "org/gnome/shell/extensions/user-theme" = {
  #     name = "Stylix";
  #   };
  # };
}
