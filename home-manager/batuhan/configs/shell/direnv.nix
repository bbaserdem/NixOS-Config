# ZSH config
{
  config,
  pkgs,
  lib,
  ...
}: let
  logFormat = "$'\\e[2;1;3mdirenv:\\e[22;23m %s\\e[0m'";
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
        log_format = logFormat;
      };
      whitelist = {
        prefix = [
          config.xdg.userDirs.extraConfig.XDG_PROJECT_DIR
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
