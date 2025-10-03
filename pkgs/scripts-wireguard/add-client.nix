# Script to add WireGuard clients dynamically
{pkgs}: let
  wg = "${pkgs.wireguard-tools}/bin/wg";
  ip = "${pkgs.iproute2}/bin/ip";
  grep = "${pkgs.gnugrep}/bin/grep";
  awk = "${pkgs.gawk}/bin/awk";
in
  pkgs.writeShellScriptBin "wireguard-add-client" ''
    # Usage: wireguard-add-client <client-name> [client-ip]
    CLIENT_NAME="$1"
    CLIENT_IP="$2"

    if [ -z "$CLIENT_NAME" ]; then
      echo "Usage: $0 <client-name> [client-ip]"
      echo "Example: $0 laptop 10.100.0.2"
      exit 1
    fi

    # Auto-assign IP if not provided
    if [ -z "$CLIENT_IP" ]; then
      # Find next available IP
      for i in {2..254}; do
        if ! ${wg} show wg0 allowed-ips | ${grep} -q "10.100.0.$i/32"; then
          CLIENT_IP="10.100.0.$i"
          break
        fi
      done
    fi

    if [ -z "$CLIENT_IP" ]; then
      echo "Error: No available IP addresses"
      exit 1
    fi

    # Generate client key pair
    CLIENT_PRIVATE_KEY=$(${wg} genkey)
    CLIENT_PUBLIC_KEY=$(echo $CLIENT_PRIVATE_KEY | ${wg} pubkey)

    # Add peer to server
    ${wg} set wg0 peer "$CLIENT_PUBLIC_KEY" allowed-ips "$CLIENT_IP/32"

    # Get server public key and endpoint
    SERVER_PUBLIC_KEY=$(${wg} show wg0 public-key)
    SERVER_ENDPOINT=$(${ip} route get 1.1.1.1 | ${awk} '{print $7; exit}'):51820

    # Generate client config
    CLIENT_CONFIG_DIR="/etc/wireguard/clients"
    mkdir -p "$CLIENT_CONFIG_DIR"

    cat > "$CLIENT_CONFIG_DIR/$CLIENT_NAME.conf" <<EOF
    [Interface]
    PrivateKey = $CLIENT_PRIVATE_KEY
    Address = $CLIENT_IP/24
    DNS = 8.8.8.8, 8.8.4.4

    [Peer]
    PublicKey = $SERVER_PUBLIC_KEY
    Endpoint = $SERVER_ENDPOINT
    AllowedIPs = 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12
    PersistentKeepalive = 25
    EOF

    echo "Client '$CLIENT_NAME' added successfully!"
    echo "IP assigned: $CLIENT_IP"
    echo "Config saved to: $CLIENT_CONFIG_DIR/$CLIENT_NAME.conf"
    echo ""
    echo "Client config:"
    cat "$CLIENT_CONFIG_DIR/$CLIENT_NAME.conf"
    echo ""
    echo "Share this config file with the client or use QR code:"
    echo "qrencode -t ansiutf8 < $CLIENT_CONFIG_DIR/$CLIENT_NAME.conf"
  ''

