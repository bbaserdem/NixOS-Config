# ZSH config
{
  config,
  pkgs,
  lib,
  ...
}: let
  esc = "\u001b"; # ESC (hex 1b, decimal 27)
  logFormat = "${esc}[2;1;3mdirenv:${esc}[22;23m %s${esc}[0m";
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
          config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR
        ];
        exact = [];
      };
    };
  };
}
