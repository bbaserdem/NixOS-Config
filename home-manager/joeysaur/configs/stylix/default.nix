# Configuring kitty
{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 32;
    };
    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      monospace = {
        name = "Inconsolata SemiCondensed";
        package = pkgs.inconsolata;
      };
      sansSerif = {
        name = "Source Sans Pro";
        package = pkgs.source-sans-pro;
      };
      serif = {
        name = "Source Serif Pro";
        package = pkgs.source-serif-pro;
      };
      sizes = {
        applications = 24;
        popups = 18;
        terminal = 18;
      };
    };
    image = ./wallpaper.png;
    imageScalingMode = "fill";
    polarity = "light";
  };
}
