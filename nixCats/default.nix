# NixCats entry point
{
  inputs,
  ...
}: let
  # Get unmolested version of nixpkgs
  inherit (inputs) nixpkgs;
  # Make utils more accessible
  inherit (inputs.nixCats) utils;

  # Path for lua file entry is here
  luaPath = "${./.}";

  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

  # the following extra_pkg_config contains any values
  # which you want to pass to the config set of nixpkgs
  # import nixpkgs { config = extra_pkg_config; inherit system; }
  # will not apply to module imports
  # as that will have your system values
  extra_pkg_config = {
    allowUnfree = true;
  };

  dependencyOverlays =
    /*
    (import ./overlays inputs) ++
    */
    [
      # see :help nixCats.flake.outputs.overlays
      # This overlay grabs all the inputs named in the format
      # `plugins-<pluginName>`
      # Once we add this overlay to our nixpkgs, we are able to
      # use `pkgs.neovimPlugins`, which is a set of our plugins.
      (utils.standardPluginOverlay inputs)
      # add any flake overlays here.

      # when other people mess up their overlays by wrapping them with system,
      # you may instead call this function on their overlay.
      # it will check if it has the system in the set, and if so return the desired overlay
      # (utils.fixSystemizedOverlay inputs.codeium.overlays
      #   (system: inputs.codeium.overlays.${system}.default)
      # )
    ];

  categoryDefinitions = {
    pkgs,
    settings,
    categories,
    extra,
    name,
    mkNvimPlugin,
    ...
  } @ packageDef: {
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
      themer = with pkgs.vimPlugins; (builtins.getAttr (categories.colorscheme or "onedark") {
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
        [ "test" "default" ]
      ];
      debug = [
        [ "debug" "default" ]
      ];
    };
  };

  packageDefinitions = {
    nixCats = {pkgs, ...}: {
      # they contain a settings set defined above
      # see :help nixCats.flake.outputs.settings
      settings = {
        wrapRc = true;
        # IMPORTANT:
        # your alias may not conflict with your other packages.
        aliases = [ "vim" "vimcat" ];
        configDirName = "nixCats-nvim";
        # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
      };
      # and a set of categories that you want
      # (and other information to pass to lua)
      categories = {
        markdown = true;
        general = true;
        lint = true;
        format = true;
        neonixdev = true;
        test = true;

        # Non-existent
        lspDebugMode = false;

        themer = true;
        colorscheme = "onedark";
      };
      extra = {
        nixdExtras = {inherit nixpkgs; };
      };
    };
  };
  regularCats = {pkgs, ... }@misc: {
    settings = {
      wrapRc = true;
      configDirName = "nixCats-nvim";
      aliases = ["testCat"];
    };
    categories = {
      markdown = true;
      general = true;
      neonixdev = true;
      lint = true;
      format = true;
      test = true;
      lspDebugMode = false;
      themer = true;
      colorscheme = "catppuccin";
    };
    extra = {
      nixdExtras = {inherit nixpkgs;};
      theBestCat = "says meow!!";
      theWorstCat = {
        thing'1 = [ "MEOW" '']]' ]=][=[HISSS]]"[['' ];
        thing2 = [
          { thing3 = [ "give" "treat" ]; }
          "I LOVE KEYBOARDS"
          (utils.n2l.types.inline-safe.mk ''[[I am a]] .. [[ lua ]] .. type("value")'')
        ];
        thing4 = "couch is for scratching";
      };

    };
  };
  # In this section, the main thing you will need to do is change the default package name
  # to the name of the packageDefinitions entry you wish to use as the default.
  defaultPackageName = "nixCats";
in
  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let
    nixCatsBuilder =
      utils.baseBuilder luaPath {
        inherit system dependencyOverlays extra_pkg_config nixpkgs;
      }
      categoryDefinitions
      packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs {inherit system;};
  in {
    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [defaultPackage];
        inputsFrom = [];
        shellHook = ''
        '';
      };
    };
  })
  // (let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
  in {
    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays =
      utils.makeOverlays luaPath {
        # we pass in the things to make a pkgs variable to build nvim with later
        inherit nixpkgs dependencyOverlays extra_pkg_config;
        # and also our categoryDefinitions
      }
      categoryDefinitions
      packageDefinitions
      defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  })
