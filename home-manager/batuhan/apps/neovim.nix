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
            base16 = stylix16;
          };
        };
      };
    };
  };

  # Make us the default
  home.sessionVariables.EDITOR = let
    nvimpkg = config.nixCats.out.packages.nixCats;
  in "${nvimpkg}/bin/${nvimpkg.nixCats_packageName}";
}
