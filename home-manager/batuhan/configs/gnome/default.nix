# Configuring gnome extensions if wanted
{pkgs, ...}: {

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
      # KDE Connect implementation
      {package = gsconnect;}
      # Clipboard
      {package = clipboard-indicator;}
      # Wallpaper slideshow
      {package = backslide;}
    ];
  };
}
