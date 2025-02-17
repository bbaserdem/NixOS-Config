# Configuring kitty
{...}: {
  # Stylix color scheme
  stylix.targets.wezterm.enable = true;

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # Stylix allows us to overwrite the config
    extraConfig = ''
      local conf = {}

      conf.window_background_opacity = 0.8
      conf.text_background_opacity = 0.8

      conf.font_size = 15.0
      conf.font = wezterm.font_with_fallback({
        {
          family = 'Iosevka',
          weight = 'Light',
          stretch = 'Normal',
          style = 'Normal',
          harfbuzz_features = { 'dlig', 'ss05', }
        }
      })
      conf.font_rules = {
        {   -- Bold
          intensity = 'Bold',
          italic = false,
          font = wezterm.font_with_fallback({
            {
              family = 'Iosevka',
              weight = 'ExtraBold',
              stretch = 'Normal',
              style = 'Normal',
              harfbuzz_features = { 'dlig', 'ss05', }
            }
          }),
        }, {-- Muted
          intensity = 'Half',
          italic = false,
          font = wezterm.font_with_fallback({
            {
              family = 'Iosevka',
              weight = 'ExtraLight',
              stretch = 'Normal',
              style = 'Normal',
              harfbuzz_features = { 'dlig', 'ss05', }
            }
          }),
        }, {-- Normal, italic
          intensity = 'Normal',
          italic = true,
          font = wezterm.font_with_fallback({
            {
              family = 'Iosevka',
              weight = 'Regular',
              stretch = 'Normal',
              style = 'Oblique',
              harfbuzz_features = { 'dlig', 'ss05', }
            }
          }),
        },  {-- Bold, italic
          intensity = 'Bold',
          italic = true,
          font = wezterm.font_with_fallback({
            {
              family = 'Iosevka',
              weight = 'Black',
              stretch = 'Normal',
              style = 'Oblique',
              harfbuzz_features = { 'dlig', 'ss05', }
            },
          }),
        }, {-- Muted and italic
          intensity = 'Half',
          italic = true,
          font = wezterm.font_with_fallback({
            {
              family = 'Iosevka',
              weight = 'Light',
              stretch = 'Normal',
              style = 'Oblique',
              harfbuzz_features = { 'dlig', 'ss05', }
            },
          }),
        },
      }

      return conf
    '';

    ###
    #font = lib.mkForce {
    #  name = "Iosevka Light";
    #  size = 15;
    #  package = pkgs.iosevka;
    #};
    #extraConfig = ''
    #  bold_font           Iosevka Heavy
    #  italic_font         Iosevka Light Italic
    #  bold_italic_font    Iosevka ExtraBold Oblique
    #  font_features       Iosevka-Light               +dlig +ss05
    #  font_features       Iosevka-Heavy               +dlig +ss05
    #  font_features       Iosevka-Light-Italic        +dlig +ss05
    #  font_features       Iosevka-ExtraBold-Oblique   +dlig +ss05
    #'';
  };
}
