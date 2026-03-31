# Neovim config
{inputs, ...}: {
  # Import the editor module
  imports = [
    inputs.dendriticFlake.modules.homeManager.editor
  ];

  # Customize package
  wrappers.neovim = {
    # Set default theme
    settings = {
      colorscheme = {
        dark = "onedark";
        light = "kanagawa-lotus";
        translucent = false;
        default = "dark";
      };
    };
  };

  programs.neovide.settings = {
    font = {
      size = 14;
      hinting = "full";
      edging = "antialias";
      normal = [
        {
          family = "Victor Mono";
          style = "Light";
        }
        {
          family = "Symbols Nerd Font Mono";
        }
      ];
      bold = [
        {
          family = "Victor Mono";
          style = "Bold";
        }
        {
          family = "Symbols Nerd Font Mono";
        }
      ];
      italic = [
        {
          family = "Victor Mono";
          style = "Light Oblique";
        }
        {
          family = "Symbols Nerd Font Mono";
        }
      ];
      bold_italic = [
        {
          family = "Victor Mono";
          style = "Bold Italic";
        }
        {
          family = "Symbols Nerd Font Mono";
        }
      ];
    };
  };
}
