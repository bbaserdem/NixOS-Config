# Neovim config
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
} @ args: let
  # Grab stylix override
  stylix16 = builtins.mapAttrs (k: v: "#" + v) (
    pkgs.lib.filterAttrs (
      k: v:
        builtins.match "base0[0-9A-F]" k != null
    )
    config.lib.stylix.colors
  );

  # We will override the full nixCats with our flake info.
  myNixCats = pkgs.neovim-nixCats-full.override (prev: {
    packageDefinitions =
      prev.packageDefinitions
      // {
        myNixCats =
          pkgs.neovim-nixCats-full.utils.mergeCatDefs
          prev.packageDefinitions.neovim-nixCats-full
          ({pkgs, ...}: {
            settings = {
              aliases = [
                # Don't need the full prefix
                "neovim-nixCats"
                "nvim-nixCats"
                "neovimCats"
                "nvimCats"
                "nx"
              ];
              # Make us use the local nvim config
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
              # Pass configuration to obsidian.nvim
              obsidian.workspaces = [
                {
                  name = "Personal";
                  path = config.xdg.userDirs.extraConfig.XDG_NOTES_DIR;
                }
              ];
            };
          });
      };
    name = "myNixCats";
  });
in {
  # NixCats
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
          # Pass configuration to obsidian.nvim
          obsidian.workspaces = [
            {
              name = "Personal";
              path = config.xdg.userDirs.extraConfig.XDG_NOTES_DIR;
            }
          ];
        };
      };
    };
  };

  # Get our nixcats, and use it as our default editor with the nx command
  home = {
    packages = [
      #myNixCats
    ];
    sessionVariables = {
      EDITOR = "nx";
    };
  };

  # Can we enable stylix?
  stylix.targets.neovim = {
    enable = true;
    plugin = "mini.base16";
  };

  # Enable neovide; ide for neovim
  programs.neovide = {
    enable = true;
    settings = {
      neovim-bin = "nx";
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

  # Helix editor config
  programs.helix = {
    enable = true;
    package = pkgs.unstable.helix;
    defaultEditor = false;
    settings = {
      theme = "ferra";
      editor = {
        line-number = "relative";
        mouse = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
      };
    };
  };
}
