# Configuring SSH servers
{
  pkgs,
  config,
  ...
}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = false;
    enableFishIntegration = false;
    enableIonIntegration = false;
    enableNushellIntegration = false;
    settings = {
    };
  };
}
