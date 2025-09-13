# ZSH config
{
  config,
  pkgs,
  lib,
  ...
}: let
  logFormat = "\"$(printf '\\033[2;1;3mdirenv:\\033[22;23m %%s\\033[0m')\"";
in {
  # Enable direnv for our shells
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        load_dotenv = false;
        warn_timeout = "0";
      };
      whitelist = {
        prefix = [
          config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR
        ];
        exact = [];
      };
    };
  };

  # Reformat direnv output to be muted
  home.sessionVariables = {
    "DIRENV_LOG_FORMAT" = logFormat;
  };
}
