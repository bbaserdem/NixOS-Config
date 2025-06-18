# Powerlevel10k enabling module, that applies my p10k config
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.p10k;
  p10kZshConfigEarlyInit = lib.mkBefore ''
    #--START--p10k-ZSH Config before everything
    if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
    #---END---p10k-ZSH Config before everything
  '';
  p10kZshConfig = lib.mkOrder 1000 ''
    #--START--p10k-ZSH Config
    # Prompt theme
    if [[ -r "${config.xdg.configHome}/powerlevel10k/config.zsh" ]]; then
      # prompt off
      source "${config.xdg.configHome}/powerlevel10k/config.zsh"
    fi
    # Recommended by p10k to add this after enabling spaceship theme globally
    (( ! ''${+functions[p10k]} )) || p10k finalize
    #---END---p10k-ZSH Config  '';
in {
  options.myHome.p10k.enable = lib.mkEnableOption "Apply p10k config to zsh";

  config = lib.mkIf cfg.enable {
    # We will put the config file for powerlevel10k in it's own directory
    xdg.configFile."powerlevel10k/config.zsh" = {
      source = ./powerlevel10k_config.zsh;
      executable = false;
    };
    # Setup zsh to use p10k
    programs.zsh = {
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initContent = lib.mkMerge [
        p10kZshConfigEarlyInit
        p10kZshConfig
      ];
    };
  };
}
