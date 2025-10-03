# Script to remove WireGuard clients dynamically
{pkgs}: let
  wg = "${pkgs.wireguard-tools}/bin/wg";
  grep = "${pkgs.gnugrep}/bin/grep";
  cut = "${pkgs.coreutils}/bin/cut";
in
  pkgs.writeShellScriptBin "wireguard-remove-client" ''
    CLIENT_NAME="$1"

    if [ -z "$CLIENT_NAME" ]; then
      echo "Usage: $0 <client-name>"
      exit 1
    fi

    CLIENT_CONFIG="/etc/wireguard/clients/$CLIENT_NAME.conf"

    if [ ! -f "$CLIENT_CONFIG" ]; then
      echo "Error: Client config not found: $CLIENT_CONFIG"
      exit 1
    fi

    # Extract public key from config
    CLIENT_PUBLIC_KEY=$(${grep} -A 10 "\[Peer\]" "$CLIENT_CONFIG" | ${grep} "PublicKey" | ${cut} -d' ' -f3)

    if [ -n "$CLIENT_PUBLIC_KEY" ]; then
      # Remove peer from server
      ${wg} set wg0 peer "$CLIENT_PUBLIC_KEY" remove
      echo "Client '$CLIENT_NAME' removed from server"
    fi

    # Remove config file
    rm "$CLIENT_CONFIG"
    echo "Client config deleted: $CLIENT_CONFIG"
  ''