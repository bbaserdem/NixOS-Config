# Configuring SSH servers
{
  pkgs,
  config,
  ...
}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
    enableIonIntegration = false;
    enableNushellIntegration = false;
    settings = {
    };
  };
}
