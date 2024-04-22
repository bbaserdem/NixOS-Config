# Configuring kitty
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
  color = config.colorScheme.palette;
in {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    font = {
      name = "Iosevka";
      size = 15;
      package = pkgs.iosevka;
    }
    settings = {
      disable_ligatures = "cursor";
      force_ltr = false;
      enable_audio_bell = false;
      cursor_shape = "block";
      cursor_blink_interval = 0.5;
      cursor_stop_blinking_after = 0.5;
      scrollback_lines = 5000;
      url_style = "curly";
      open_url_modifiers = "kitty_mod";
      open_url_with = "default";
      copy_on_select = false;
      tab_separator = " ┇";
      # Color settings
      cursor = "#${color.base06}";
      cursor_text_color = "background";
      url_color = "#${color.base0D}";
      visual_bell_color = "#${color.base0C}";
      bell_border_color = "#${color.base0C}";
      active_border_color = "#${color.base0E}";
      inactive_border_color = "#${color.base03}";
      foreground = "#${color.base06}";
      background = "#${color.base00}";
      selection_foreground = "#${color.base02}";
      selection_background = "#${color.base06}";
      active_tab_foreground = "#${color.base06}";
      active_tab_background = "#${color.base03}";
      inactive_tab_foreground = "#${color.base04}";
      inactive_tab_background = "#${color.base01}";
      # = "black  (bg3/bg4)";
      color0 = "#${color.base03}";
      color8 = "#${color.base04}";
      # = "red";
      color1 = "#${color.base08}";
      color9 = "#${color.base08}";
      #: = "green";
      color2 = "#${color.base0B}";
      color10 = "#${color.base0B}";
      # = "yellow";
      color3 = "#${color.base0A}";
      color11 = "#${color.base0A}";
      # = "blue";
      color4 = "#${color.base0D}";
      color12 = "#${color.base0D}";
      # = "purple";
      color5 = "#${color.base0E}";
      color13 = "#${color.base0E}";
      # = "aqua";
      color6 = "#${color.base0C}";
      color14 = "#${color.base0C}";
      # = "white (fg4/fg3)";
      color7 = "#${color.base05}";
      color15 = "#${color.base06}";
      # scrollback_pager = ''nvim -c "set signcolumn=no showtabline=0" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - "'';
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      shell_integration = "enabled";
    };
    extraConfig = ''
      font_family         Iosevka Light
      bold_font           Iosevka Heavy
      italic_font         Iosevka Light Italic
      bold_italic_font    Iosevka ExtraBold Oblique
      font_features       Iosevka Light               +dlig +ss05
      font_features       Iosevka Heavy               +dlig +ss05
      font_features       Iosevka Light Italic        +dlig +ss05
      font_features       Iosevka ExtraBold Oblique   +dlig +ss05
      # Nerd Font override
      # https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
      symbol_map U+E5FA-U+E62B    Symbols Nerd Font Mono
      # Devicons
      symbol_map U+e700-U+e7c5    Symbols Nerd Font Mono
      # Font Awesome
      symbol_map U+f000-U+f2e0    Symbols Nerd Font Mono
      # Font Awesome Extension
      symbol_map U+e200-U+e2a9    Symbols Nerd Font Mono
      # Material Design Icons
      symbol_map U+f0001-U+f1af0  Symbols Nerd Font Mono
      # Weather
      symbol_map U+e300-U+e3e3    Symbols Nerd Font Mono
      # Octicons
      symbol_map U+f400-U+f532    Symbols Nerd Font Mono
      symbol_map U+2665           Symbols Nerd Font Mono
      symbol_map U+26A1           Symbols Nerd Font Mono
      # [Powerline Symbols]
      symbol_map U+e0a0-U+e0a2    Symbols Nerd Font Mono
      symbol_map U+e0b0-U+e0b3    Symbols Nerd Font Mono
      # Powerline Extra Symbols
      symbol_map U+e0b4-U+e0c8    Symbols Nerd Font Mono
      symbol_map U+e0cc-U+e0d4    Symbols Nerd Font Mono
      symbol_map U+e0a3           Symbols Nerd Font Mono
      symbol_map U+e0ca           Symbols Nerd Font Mono
      # IEC Power Symbols
      symbol_map U+23fb-U+23fe    Symbols Nerd Font Mono
      symbol_map U+2b58           Symbols Nerd Font Mono
      # Font Logos (Formerly Font Linux)
      symbol_map U+f300-U+f32f    Symbols Nerd Font Mono
      # Pomicons
      symbol_map U+e000-U+e00a    Symbols Nerd Font Mono
      # Codicons
      symbol_map U+ea60-U+ebeb    Symbols Nerd Font Mono
      # Heavy Angle Brackets
      symbol_map U+e276c-U+2771   Symbols Nerd Font Mono
      # Box Drawing
      symbol_map U+2500-U+259f    Symbols Nerd Font Mono
    '';
  };
}
