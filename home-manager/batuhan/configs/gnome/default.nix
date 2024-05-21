# Configuring gnome extensions if wanted
{
  pkgs,
  config,
  ...
}: {
  # Some gnome extensions
  # This needs home-manager unstable, enable after 24.05
  # programs.gnome-shell = {
    # enable = true;
    # extensions = with pkgs; [
      # { package = gnomeExtensions.appindicator; }
      # { package = gnomeExtensions.wireless-hid; }
      # { package = gnomeExtensions.usd-try; }
    # ];
  # };
  # Enable firefox to integrate too
  programs.firefox.enableGnomeExtensions = true;
}
