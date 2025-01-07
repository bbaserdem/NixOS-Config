# The category definitions
{
  pkgs,
  settings,
  categories,
  extra,
  name,
  mkNvimPlugin,
  ...
} @ packageDef: {
  # The LSP's required to run stuff
  lspsAndRuntimeDeps = {
    general = with pkgs; [
      universal-ctags
      ripgrep
      fd
    ];
    neonixdev = with pkgs; [
      nix-doc
      lua-language-server
      nixd
    ];
  };

  startupPlugins = {
    debug = with pkgs.vimPlugins; [
      nvim-nio
    ];
    general = with pkgs.vimPlugins; {
      always = [
        lze
        vim-repeat
        plenary-nvim
      ];
      extra = [
        oil-nvim
        nvim-web-devicons
      ];
    };
    themer = with pkgs.vimPlugins; (
      builtins.getAttr (categories.colorscheme or "onedark") {
        # Theme switcher without creating a new category
        "onedark" = onedark-nvim;
        "catppuccin" = catppuccin-nvim;
        "catppuccin-mocha" = catppuccin-nvim;
        "tokyonight" = tokyonight-nvim;
        "tokyonight-day" = tokyonight-nvim;
      }
    );
  };

  optionalPlugins = {
    debug = with pkgs.vimPlugins; {
      default = [
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
      ];
    };
    lint = with pkgs.vimPlugins; [
      nvim-lint
    ];
    format = with pkgs.vimPlugins; [
      conform-nvim
    ];
    markdown = with pkgs.vimPlugins; [
      markdown-preview-nvim
    ];
    neonixdev = with pkgs.vimPlugins; [
      lazydev-nvim
    ];
    general = {
      cmp = with pkgs.vimPlugins; [
        # cmp stuff
        nvim-cmp
        luasnip
        friendly-snippets
        cmp_luasnip
        cmp-buffer
        cmp-path
        cmp-nvim-lua
        cmp-nvim-lsp
        cmp-cmdline
        cmp-nvim-lsp-signature-help
        cmp-cmdline-history
        lspkind-nvim
      ];
      treesitter = with pkgs.vimPlugins; [
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
      ];
      telescope = with pkgs.vimPlugins; [
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        telescope-nvim
      ];
      always = with pkgs.vimPlugins; [
        nvim-lspconfig
        lualine-nvim
        gitsigns-nvim
        vim-sleuth
        vim-fugitive
        vim-rhubarb
        nvim-surround
      ];
      extra = with pkgs.vimPlugins; [
        fidget-nvim
        lualine-lsp-progress
        which-key-nvim
        comment-nvim
        undotree
        indent-blankline-nvim
        vim-startuptime
      ];
    };
  };

  # shared libraries to be added to LD_LIBRARY_PATH
  # variable available to nvim runtime
  sharedLibraries = {
    general = with pkgs; [
      libgit2
    ];
  };

  environmentVariables = {
    test = {
      CATTESTVAR = "It worked!";
    };
  };

  extraWrapperArgs = {
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
    test = [
      ''--set CATTESTVAR2 "It worked again!"''
    ];
  };

  # lists of the functions you would have passed to
  # python.withPackages or lua.withPackages

  # get the path to this python environment
  # in your lua config via
  # vim.g.python3_host_prog
  # or run from nvim terminal via :!<packagename>-python3
  extraPython3Packages = {
    test = _: [];
  };
  # populates $LUA_PATH and $LUA_CPATH
  extraLuaPackages = {
    test = [(_: [])];
  };
  extraCats = {
    test = [
      ["test" "default"]
    ];
    debug = [
      ["debug" "default"]
    ];
  };
}
