# Module that enables sunshine, streams steam to moonlight
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Networking
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 47984;
      to = 48010;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 47984;
      to = 48010;
    }
  ];
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };
  # Systemd service
  systemd.user.services.sunshine = {
    description = "Sunshine self-hosted game stream host for Moonlight";
    startLimitBurst = 5;
    startLimitIntervalSec = 500;
    serviceConfig = {
      ExecStart = "${config.security.wrapperDir}/sunshine";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
