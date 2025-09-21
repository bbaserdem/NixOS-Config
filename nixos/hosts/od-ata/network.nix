{
  config,
  pkgs,
  ...
}: {
  # Safe network configuration from nixos default
  networking = {
    useNetworkd = true;
    firewall.allowedUDPPorts = [5353];
  };
  systemd.network.networks = {
    "99-ethernet-default-dhcp".networkConfig.MulticastDNS = "yes";
  };

  # Lifted from 'srvos'; don't take down the network for too long when upgrading
  systemd.services = {
    systemd-networkd.stopIfChanged = false;
    systemd-resolved.stopIfChanged = false;
  };
}
