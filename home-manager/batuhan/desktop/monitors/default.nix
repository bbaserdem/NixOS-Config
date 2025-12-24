# home-manager/batuhan/desktop/monitors/default.nix
# Kanshi entry point
{host, ...}: {
  imports = [
    ./${host}.nix
  ];

  services.kanshi = {
    enable = true;
  };
}
