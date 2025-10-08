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
      echo "Environment: WIREGUARD_SERVER_ENDPOINT=your.server.com:51820"
      exit 1
    fi

    # Check if WireGuard interface exists
    if ! ${wg} show wg0 >/dev/null 2>&1; then
      echo "Error: WireGuard interface wg0 not found or not running"
      exit 1
    fi

    # Check if client already exists
    CLIENT_KEY_MAP="/etc/wireguard/client-keys"
    if [ -f "$CLIENT_KEY_MAP" ] && ${grep} -q "^$CLIENT_NAME:" "$CLIENT_KEY_MAP"; then
      echo "Error: Client '$CLIENT_NAME' already exists"
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
    if ! ${wg} set wg0 peer "$CLIENT_PUBLIC_KEY" allowed-ips "$CLIENT_IP/32"; then
      echo "Error: Failed to add peer to WireGuard interface"
      exit 1
    fi

    # Store client public key for removal later
    CLIENT_KEY_MAP="/etc/wireguard/client-keys"
    mkdir -p "$(dirname "$CLIENT_KEY_MAP")"
    echo "$CLIENT_NAME:$CLIENT_PUBLIC_KEY:$CLIENT_IP" >> "$CLIENT_KEY_MAP"

    # Get server public key and endpoint
    SERVER_PUBLIC_KEY=$(${wg} show wg0 public-key)
    if [ -z "$SERVER_PUBLIC_KEY" ]; then
      echo "Error: Could not get server public key. Is WireGuard running?"
      exit 1
    fi

    # Use configurable endpoint or auto-detect
    if [ -n "$WIREGUARD_SERVER_ENDPOINT" ]; then
      SERVER_ENDPOINT="$WIREGUARD_SERVER_ENDPOINT"
    else
      SERVER_IP=$(${ip} route get 1.1.1.1 2>/dev/null | ${awk} '{print $7; exit}')
      if [ -z "$SERVER_IP" ]; then
        echo "Warning: Could not auto-detect server IP. Set WIREGUARD_SERVER_ENDPOINT environment variable."
        SERVER_ENDPOINT="YOUR_SERVER_IP:51820"
      else
        SERVER_ENDPOINT="$SERVER_IP:51820"
      fi
    fi

    # Generate client config
    CLIENT_CONFIG_DIR="/etc/wireguard/clients"
    if ! mkdir -p "$CLIENT_CONFIG_DIR"; then
      echo "Error: Could not create client config directory"
      exit 1
    fi

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

