# nixos/services/wireguard.nix
# Set up wireguard access to the vpn server od-ata
{
  config,
  pkgs,
  lib,
  ...
}: let
  host = config.networking.hostName;
  publickey = "9JZyVGNWJhkIWFxxcOcqYg4zzqs+EJ12/AQd+jwa0AE=";
in {
  # Drop in the config file
  environment.etc."wireguard/wg0.conf" = {
    text = ''
      [Interface]
      Address = 10.100.0.3/24

      PostUp = wg set %i private-key ${config.sops.secrets."wireguard/private/${host}".path}
      PostUp = wg set %i preshared-key ${config.sops.secrets."wireguard/preshared/od-ata/${host}".path}

      [Peer]
      PublicKey = ${publickey}
      Endpoint = od-ata.local:51820
      AllowedIPs = 0.0.0.0/0
      PersistentKeepalive = 25
    '';
    mode = "600";
  };

  # Enable WireGuard ports
  networking.firewall.allowedUDPPorts = [51820];

  # Install wireguard
  environment.systemPackages = [pkgs.wireguard-tools];
}
