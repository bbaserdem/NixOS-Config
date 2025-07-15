# ZSH config
{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  # Enable direnv for our shells
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Reformat direnv output to be muted
  home.sessionVariables = {
    "DIRENV_LOG_FORMAT" = "\x1b[2;1;3mdirenv:\x1b[22;23m %s\x1b[0m";
  };
}
