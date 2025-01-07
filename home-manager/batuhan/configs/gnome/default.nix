# Configuring gnome extensions if wanted
{pkgs, ...}: {
  # Some gnome extensions
  programs.gnome-shell = {
    enable = true;
    extensions = [
      {package = pkgs.gnomeExtensions.appindicator;}
      {package = pkgs.gnomeExtensions.wireless-hid;}
      {package = pkgs.gnomeExtensions.syncthing-toggle;}
    ];
  };
}
