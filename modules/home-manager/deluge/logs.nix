{pkgs, ...}:
pkgs.writeShellScriptBin "deluge-vpn-logs" ''
  #!/usr/bin/env bash
  echo "=== VPN Container Logs ==="
  ${pkgs.docker}/bin/docker logs deluge-vpn-wireguard --tail=20
  echo
  echo "=== Deluge Daemon Container Logs ==="
  ${pkgs.docker}/bin/docker logs deluge-daemon --tail=20
  echo
  echo "=== Deluge Web Container Logs ==="
  ${pkgs.docker}/bin/docker logs deluge-web --tail=20
''