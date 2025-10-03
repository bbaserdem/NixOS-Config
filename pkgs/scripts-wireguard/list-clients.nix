# Script to list WireGuard clients
{pkgs}: let
  wg = "${pkgs.wireguard-tools}/bin/wg";
  ls = "${pkgs.coreutils}/bin/ls";
in
  pkgs.writeShellScriptBin "wireguard-list-clients" ''
    echo "Active WireGuard peers:"
    ${wg} show wg0 peers | while read peer; do
      if [ -n "$peer" ]; then
        allowed_ips=$(${wg} show wg0 peer "$peer" allowed-ips)
        endpoint=$(${wg} show wg0 peer "$peer" endpoint)
        latest_handshake=$(${wg} show wg0 peer "$peer" latest-handshake)

        echo "Peer: $peer"
        echo "  Allowed IPs: $allowed_ips"
        echo "  Endpoint: $endpoint"
        echo "  Latest handshake: $latest_handshake"
        echo ""
      fi
    done

    echo "Available client configs:"
    ${ls} -la /etc/wireguard/clients/ 2>/dev/null || echo "No client configs found"
  ''

