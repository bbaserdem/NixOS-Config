# Example configuration for Deluge VPN service
# Add this to your home-manager configuration to enable the service

{
  services.deluge-vpn = {
    enable = true;

    # Optional: Override default directories (relative to home)
    downloadsDir = "Shared/Torrent";           # ~/Shared/Torrent
    configDir = ".config/deluge";              # ~/.config/deluge
    mullvadConfigPath = ".config/mullvad/wg0.conf";  # ~/.config/mullvad/wg0.conf

    # Optional: Override default ports
    webPort = 8112;    # Deluge web interface
    daemonPort = 58846; # Deluge daemon port
  };
}