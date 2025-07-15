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
    "DIRENV_LOG_FORMAT" = "$'\\e[2;1;3mdirenv:\\e[22;23m %s\\e[0m'";
  };
}
