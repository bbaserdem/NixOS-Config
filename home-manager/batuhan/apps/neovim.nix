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
in {
  # Neovim nixCats
  nixCats = {
    enable = true;
    nixpkgs_version = inputs.nixpkgs-unstable;
    packageNames = ["neovim-nixCats-full"];
    packageDefinitions.replace = {
      neovim-nixCats-full = {pkgs, ...}: {
        settings = {
          aliases = [
            # Don't need the full prefix
            "neovim-nixCats"
            "nvim-nixCats"
            "neovimCats"
            "nvimCats"
            "nx"
          ];
          configDirName = "nvim-nixCats";
        };
        extra = {
          # Pass configuration to nixd
          nix = {
            inherit (args) host user;
            flake = outputs.lib.rootDir;
          };
          colorscheme = {
            base16 = stylix16;
          };
        };
      };
    };
  };

  # Make us the default
  home.sessionVariables.EDITOR = let
    nvimpkg = config.nixCats.out.packages.neovim-nixCats-full;
  in "${nvimpkg}/bin/${nvimpkg.nixCats_packageName}";

  # Enable neovide; ide for neovim
  programs.neovide = {
    enable = true;
    settings = {
      neovim-bin = config.home.sessionVariables.EDITOR;
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
