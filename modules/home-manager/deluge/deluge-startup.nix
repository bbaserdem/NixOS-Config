{pkgs, ...}:
pkgs.writeShellScript "deluge-startup" ''
  # Wait for network to be ready (VPN container)
  while ! ${pkgs.curl}/bin/curl -s --connect-timeout 5 ifconfig.me > /dev/null; do
    echo "Waiting for VPN connection..."
    sleep 10
  done

  echo "VPN connection confirmed, starting Deluge..."

  # Start Deluge daemon
  exec ${pkgs.deluge}/bin/deluged --do-not-daemonize --config /config --logfile /var/log/deluge.log --loglevel info
''