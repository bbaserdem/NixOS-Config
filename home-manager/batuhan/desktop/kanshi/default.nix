# home-manager/batuhan/desktop/kanshi/default.nix
# Kanshi; monitor hotswap manager entry point
{...}: {
  imports = [
    ./monitors.nix
    ./profiles.nix
  ];

  services.kanshi = {
    enable = true;
  };
}
