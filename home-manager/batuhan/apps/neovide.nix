# Neovim config
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
} @ args: let
  nvimPkg = config.nixCats.out.packages.neovim-nixCats-full;
  nvimExe = "${nvimPkg}/bin/${nvimPkg.nixCats_packageName}";
in {
  # Enable neovide; ide for neovim
  programs.neovide = {
    enable = true;
    settings = {
      neovim-bin = nvimExe;
      fork = true;
      frame = "full";
      idle = true;
      mouse-cursor-icon = "arrow";
      no-multigrid = false;
      tabs = false;
      theme = "auto";
      font = {
        size = 14.0;
        normal = [
          {
            family = "JetBrains Mono";
            style = "Normal";
          }
          {
            family = "Symbols Nerd Font Mono";
            style = "Regular";
          }
        ];
        bold = [
          {
            family = "JetBrains Mono";
            style = "ExtraBold";
          }
          {
            family = "Symbols Nerd Font Mono";
            style = "Regular";
          }
        ];
        italic = [
          {
            family = "JetBrains Mono";
            style = "Light Italic";
          }
          {
            family = "Symbols Nerd Font Mono";
            style = "Regular";
          }
        ];
        bold_italic = [
          {
            family = "JetBrains Mono";
            style = "Bold Italic";
          }
          {
            family = "Symbols Nerd Font Mono";
            style = "Regular";
          }
        ];
      };
    };
  };
}
