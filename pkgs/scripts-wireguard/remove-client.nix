# Script to remove WireGuard clients dynamically
{pkgs}: let
  wg = "${pkgs.wireguard-tools}/bin/wg";
  grep = "${pkgs.gnugrep}/bin/grep";
  cut = "${pkgs.coreutils}/bin/cut";
  mv = "${pkgs.coreutils}/bin/mv";
in
  pkgs.writeShellScriptBin "wireguard-remove-client" ''
    CLIENT_NAME="$1"

    if [ -z "$CLIENT_NAME" ]; then
      echo "Usage: $0 <client-name>"
      exit 1
    fi

    # Check if WireGuard interface exists
    if ! ${wg} show wg0 >/dev/null 2>&1; then
      echo "Error: WireGuard interface wg0 not found or not running"
      exit 1
    fi

    CLIENT_CONFIG="/etc/wireguard/clients/$CLIENT_NAME.conf"
    CLIENT_KEY_MAP="/etc/wireguard/client-keys"

    # Get client public key from our mapping file
    if [ ! -f "$CLIENT_KEY_MAP" ]; then
      echo "Error: Client key mapping not found: $CLIENT_KEY_MAP"
      exit 1
    fi

    CLIENT_ENTRY=$(${grep} "^$CLIENT_NAME:" "$CLIENT_KEY_MAP" 2>/dev/null)
    if [ -z "$CLIENT_ENTRY" ]; then
      echo "Error: Client '$CLIENT_NAME' not found in key mapping"
      exit 1
    fi

    CLIENT_PUBLIC_KEY=$(echo "$CLIENT_ENTRY" | ${cut} -d':' -f2)

    if [ -z "$CLIENT_PUBLIC_KEY" ]; then
      echo "Error: Could not extract public key for client '$CLIENT_NAME'"
      exit 1
    fi

    # Remove peer from server
    if ! ${wg} set wg0 peer "$CLIENT_PUBLIC_KEY" remove; then
      echo "Warning: Failed to remove peer from WireGuard interface (may not exist)"
    else
      echo "Client '$CLIENT_NAME' removed from server"
    fi

    # Remove from key mapping
    ${grep} -v "^$CLIENT_NAME:" "$CLIENT_KEY_MAP" > "$CLIENT_KEY_MAP.tmp" && ${mv} "$CLIENT_KEY_MAP.tmp" "$CLIENT_KEY_MAP"

    # Remove config file
    if [ -f "$CLIENT_CONFIG" ]; then
      rm "$CLIENT_CONFIG"
      echo "Client config deleted: $CLIENT_CONFIG"
    else
      echo "Warning: Client config not found: $CLIENT_CONFIG"
    fi

    echo "Client '$CLIENT_NAME' removal completed"
  ''