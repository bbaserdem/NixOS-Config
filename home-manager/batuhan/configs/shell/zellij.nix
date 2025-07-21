# Zellij config
{pkgs, ...}: {
  # Enable theming
  stylix.targets.zellij.enable = true;

  # Settings
  programs.zellij = {
    enable = true;
    # Shell integrations
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    # Behavior
    attachExistingSession = false;
    exitShellOnExit = false;
    # Settings
    settings = {
      copy_command = "${pkgs.wl-clipboard}/bin/wl-copy";
      copy_on_select = false;
    };
  };
}
