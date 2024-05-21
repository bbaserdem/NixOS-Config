# Configuring gnome extensions if wanted
{
  pkgs,
  config,
  ...
}: {
  # Some gnome extensions
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs; [
      { package = gnomeExtensions.appindicator; }
      { package = gnomeExtensions.wireless-hid; }
      { package = gnomeExtensions.usd-try; }
    ];
  };
  # Enable firefox to integrate too
  programs.firefox.enableGnomeExtensions = true;
}
