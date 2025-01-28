# Zathura layout
{
  config,
  pkgs,
  ...
}: let
  colors = config.colorScheme.palette;
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
      #default-bg = "#${colors.base00}";
      #default-fg = "#${colors.base01}";
      #statusbar-bg = "#${colors.base01}";
      #statusbar-fg = "#${colors.base04}";
      #inputbar-bg = "#${colors.base00}";
      #inputbar-fg = "#${colors.base02}";
      #notification-bg = "#${colors.base0B}";
      #notification-fg = "#${colors.base00}";
      #notification-error-bg = "#${colors.base08}";
      #notification-error-fg = "#${colors.base00}";
      #notification-warning-bg = "#${colors.base08}";
      #notification-warning-fg = "#${colors.base00}";
      #highlight-color = "#${colors.base0A}";
      #highlight-active-color = "#${colors.base0D}";
      #completion-bg = "#${colors.base02}";
      #completion-fg = "#${colors.base0C}";
      #completion-highlight-bg = "#${colors.base0C}";
      #completion-highlight-fg = "#${colors.base02}";
      #recolor-lightcolor = "#${colors.base00}";
      #recolor-darkcolor = "#${colors.base06}";
    };
  };
}
