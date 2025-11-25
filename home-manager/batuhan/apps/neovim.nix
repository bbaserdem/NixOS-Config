# Neovim config
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
} @ args: let
  # Grab stylix override
  stylix16 =
    pkgs.lib.filterAttrs
    (k: v: builtins.match "base0[0-9A-F]" k != null)
    config.lib.stylix.colors.withHashtag;
  nvimPkg = config.nixCats.out.packages.nixCats;
  nvimExe = "${nvimPkg}/bin/${nvimPkg.nixCats_packageName}";
in {
  # Neovim nixCats
  nixCats = {
    enable = true;
    nixpkgs_version = inputs.nixpkgs-unstable;
    packageNames = ["nixCats"];
    packageDefinitions.replace = {
      nixCats = {pkgs, ...}: {
        extra = {
          # Pass configuration to nixd
          nix = {
            inherit (args) host user;
            flake = outputs.lib.rootDir;
          };
          colorscheme = {
            name = "stylix";
            base16 = stylix16;
          };
        };
      };
    };
  };

  # Make us the default
  home.sessionVariables.EDITOR = nvimExe;

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
