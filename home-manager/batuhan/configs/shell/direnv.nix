# ZSH config
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable direnv for our shells
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Reformat direnv output to be muted
  home.sessionVariables = {
    "DIRENV_LOG_FORMAT" = "$'\\033[2mdirenv: %s\\033[0m'";
  };
}
