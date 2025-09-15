# ZSH config
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Integrations
  home.shell.enableZshIntegration = true;
  programs.fzf.enableBashIntegration = true;
  programs.direnv.enableBashIntegration = true;
  programs.kitty.shellIntegration.enableBashIntegration = true;
  programs.nix-index.enableBashIntegration = true;
  programs.starship.enableBashIntegration = true;
  programs.zoxide.enableBashIntegration = true;

  # Setup zsh
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = ["ignoredups"];
  };
}
