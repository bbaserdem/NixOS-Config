{pkgs, ...}:
pkgs.writeShellScriptBin "deluge-vpn-check" ''
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Checking Deluge VPN connectivity..."

  if ! ${pkgs.docker}/bin/docker ps | grep -q "deluge-vpn-wireguard"; then
    echo "❌ VPN container is not running"
    exit 1
  fi

  if ! ${pkgs.docker}/bin/docker ps | grep -q "deluge-daemon"; then
    echo "❌ Deluge daemon container is not running"
    exit 1
  fi

  if ! ${pkgs.docker}/bin/docker ps | grep -q "deluge-web"; then
    echo "❌ Deluge web container is not running"
    exit 1
  fi

  VPN_IP=$(${pkgs.docker}/bin/docker exec deluge-vpn-wireguard curl -s ifconfig.me || echo "failed")
  if [ "$VPN_IP" = "failed" ]; then
    echo "❌ VPN connection failed"
    exit 1
  fi

  DELUGE_IP=$(${pkgs.docker}/bin/docker exec deluge-daemon curl -s ifconfig.me || echo "failed")
  if [ "$DELUGE_IP" = "failed" ]; then
    echo "❌ Deluge cannot reach internet"
    exit 1
  fi

  if [ "$VPN_IP" = "$DELUGE_IP" ]; then
    echo "✅ VPN is working correctly"
    echo "   Public IP: $VPN_IP"
    echo "   Deluge web interface: http://localhost:8112"
    echo "   Default password: deluge"
  else
    echo "❌ IP mismatch - VPN might be leaking"
    echo "   VPN IP: $VPN_IP"
    echo "   Deluge IP: $DELUGE_IP"
    exit 1
  fi
''