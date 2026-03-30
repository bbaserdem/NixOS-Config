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
}
