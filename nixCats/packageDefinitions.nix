# Package definitions
# Each value in this attribute set should be a set function with pkgs
{
  nixCats = {pkgs, ...} @ misc: {
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
  regularCats = {pkgs, ... } @ misc: {
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
}
