# nixos/services/upower.nix
# Configuring upower power management
{...}: {
  services.upower = {
    enable = true;
    usePercentageForPolicy = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 5;
    criticalPowerAction = "HybridSleep";
  };
}
