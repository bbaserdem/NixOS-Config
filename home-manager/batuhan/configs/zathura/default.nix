# Zathura layout
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  myLib,
  rootPath,
  ...
}: let
  colors = config.colorScheme.colors;
in {
  programs.zathura = {
    enable = true;
    package = pkgs.zathura;
    mappings = {
      "<C-i>" = "recolor";
    };
    options = {
      recolor-keephue = true;
      selection-keyboard = "clipboard";
      first-page-column = "1:1";
      incremental-search = false;
      statusbar-home-tilde = true;
      scroll-page-aware = true;
      scroll-step = 50;
      # Synctex for LaTeX
      synctex = true;
      synctex-editor-command = "nvim --headless -c \\\"VimtexInverseSearch %l '%f'\\\"";
      # Colors
      default-bg =              "#${palette.base00}";
      default-fg =              "#${palette.base01}";
      statusbar-bg =            "#${palette.base01}";
      statusbar-fg =            "#${palette.base04}";
      inputbar-bg =             "#${palette.base00}";
      inputbar-fg =             "#${palette.base02}";
      notification-bg =         "#${palette.base0B}";
      notification-fg =         "#${palette.base00}";
      notification-error-bg =   "#${palette.base08}";
      notification-error-fg =   "#${palette.base00}";
      notification-warning-bg = "#${palette.base08}";
      notification-warning-fg = "#${palette.base00}";
      highlight-color =         "#${palette.base0A}";
      highlight-active-color =  "#${palette.base0D}";
      completion-bg =           "#${palette.base02}";
      completion-fg =           "#${palette.base0C}";
      completion-highlight-bg = "#${palette.base0C}";
      completion-highlight-fg = "#${palette.base02}";
      recolor-lightcolor =      "#${palette.base00}";
      recolor-darkcolor =       "#${palette.base06}";
    };
  };
}
