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
    extensions = [
      {package = pkgs.gnomeExtensions.appindicator;}
      {package = pkgs.gnomeExtensions.wireless-hid;}
      {package = pkgs.gnomeExtensions.syncthing-toggle;}
    ];
  };
}
