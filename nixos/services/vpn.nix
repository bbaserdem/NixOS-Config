# Configuring VPNs
{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    # Enable mullvad vpn
    mullvad-vpn = {
      enable = true;
      # Default is pkgs.mullvad, which is CLI only
      # This provides gui
      package = pkgs.mullvad-vpn;
      # Allows excluding apps
      enableExcludeWrapper = true;
    };
  };
}
