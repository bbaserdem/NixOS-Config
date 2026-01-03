# Configuring kitty
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Stylix color scheme
  stylix.targets.kitty.enable = true;

  # Set as default terminale
  home.sessionVariables.TERMINAL = "${config.programs.kitty.package}/bin/kitty";

  programs.kitty = {
    enable = true;

    # We mkForce to override stylix
    font = lib.mkForce {
      #name = "Victor Mono";
      #package = pkgs.victor-mono;
      name = "Iosevka Light";
      package = pkgs.iosevka;
      size = 13;
    };

    # General settings
    settings = {
      disable_ligatures = "cursor";
      background_blur = "8";
      force_ltr = false;
      enable_audio_bell = false;
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = 0;
      cursor_trail = 3;
      scrollback_lines = 5000;
      url_style = "curly";
      open_url_with = "default";
      copy_on_select = false;
      tab_separator = " ┇";
      # scrollback_pager = ''${config.home.sessionVariables.EDITOR} -c "set signcolumn=no showtabline=0" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - "'';
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";
      shell_integration = true;
    };
    extraConfig = ''
      # Liberate ctrl+tab
      map ctrl+tab        send_text normal,application \x1b[9;5u
      map ctrl+shift+tab  send_text normal,application \x1b[9;6u

      # Iosevka overrides Fonts I want
      bold_font           Iosevka Heavy
      italic_font         Iosevka Light Italic
      bold_italic_font    Iosevka ExtraBold Oblique
      font_features       Iosevka-Light               +dlig +ss05
      font_features       Iosevka-Heavy               +dlig +ss05
      font_features       Iosevka-Light-Italic        +dlig +ss05
      font_features       Iosevka-ExtraBold-Oblique   +dlig +ss05

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
      symbol_map U+276c-U+2771   Symbols Nerd Font Mono
      # Box Drawing
      symbol_map U+2500-U+259f    Symbols Nerd Font Mono

      # Fix macos stuff
      macos_titlebar_color system
    '';
  };
}
