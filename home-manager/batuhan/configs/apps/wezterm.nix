# Configuring kitty
{
  ...
}: {

  # Stylix color scheme
  stylix.targets.wezterm.enable = true;

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # Stylix allows us to overwrite the config
    extraConfig = ''
      local wezterm = require('wezterm')
      local myConfig = {}

      return myConfig
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
