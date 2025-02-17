# Neovim config
{
  outputs,
  config,
  pkgs,
  ...
} @ args: let

  # We will override the full nixCats with our flake info.
  myCats = pkgs.nixCats-full.override (prev: {
    packageDefinitions = prev.packageDefinitions // {
      myCats =
        pkgs.nixCats-full.utils.mergeCatDefs
        prev.packageDefinitions.neovim-nixCats-full
        ({ pkgs, ... }: {
          settings = {
            aliases = [
              # Don't need the full prefix
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
              flake = outputs.self;
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
    name = "myCats";
  });

in {

  # Get our nixcats, and use it as our default editor with the nx command 
  home = {
    packages = [
      myCats
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
