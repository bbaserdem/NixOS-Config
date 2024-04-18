# Module that brings in fonts

{ pkgs, lib, ... }: {
  fonts = {
    #enableDefaultPackages = true;
    # Fonts we will use
    packages = with pkgs; [
      nerdfont-standalone         # Defined in overlays, glyphs
      noto-fonts-monochrome-emoji # Emoji fonts
      noto-fonts-color-emoji
      _3270font                   # Monospace
      fira-code                   # Monospace with ligatures
      liberation_ttf              # Windows compat.
      caladea                     #   Office fonts alternative
      carlito                     #   Calibri/georgia alternative
      inconsolata                 # Monospace font, for prints
      iosevka                     # Monospace font, for terminal mostly
      jetbrains-mono              # Readable monospace font
      noto-fonts
      source-serif-pro
      source-sans-pro
      curie                       # Bitmap fonts
      tamsyn
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [
          "Symbols Nerd Font"
          "Source Serif Pro"
          "Noto Color Emoji"
          "Noto Sans"
        ];
        sansSerif = [
          "Symbols Nerd Font"
          "Noto Sans"
          "Noto Color Emoji"
        ];
        monospace = [
          "Symbols Nerd Font"
          "Iosevka"
          "Noto Emoji"
        ];
      };
    };
  };
}
