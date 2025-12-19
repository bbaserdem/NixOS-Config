# Neovim config
{
  inputs,
  outputs,
  lib,
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
in (
  lib.mkMerge [
    {
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
                # Inject the base16 colorset to the stylix theme (uses mini.base16)
                base16 = stylix16;
                translucent = false;
                # Set dark and light colorschemes
                dark = "kanagawa-dragon";
                light = "catppuccin-latte";
              };
            };
          };
        };
      };

      # Make us the default
      home.sessionVariables.EDITOR = nvimExe;
    }
    (lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
      # Enable neovide; ide for neovim
      stylix.targets.neovide.enable = true;
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
        };
      };
    })
  ]
)
