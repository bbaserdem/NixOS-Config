# NixCats entry point
{
  inputs,
  outputs,
  ...
}: let
  # Get unmolested version of nixpkgs
  inherit (inputs) nixpkgs;

  # Make utils more accessible
  inherit (inputs.nixCats) utils;

  # Path for lua file entry is here
  luaPath = "${./.}";

  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

  extra_pkg_config = {
    allowUnfree = true;
  };

  dependencyOverlays = [
    (utils.standardPluginOverlay inputs)
  ];

  categoryDefinitions = import ./categoryDefinitions.nix;
  packageDefinitions = import ./packageDefinitions.nix;

  # Default package to use from packageDefinitions
  defaultPackageName = "nixCats";
in
  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let

    # The builder function
    nixCatsBuilder =
      utils.baseBuilder luaPath {
        inherit system dependencyOverlays extra_pkg_config nixpkgs;
      }
      categoryDefinitions
      packageDefinitions;

    # Setting the default package
    defaultPackage = nixCatsBuilder defaultPackageName;

    # For using utils, the pkgs for <cat|pkg>Defs are defined inside the builder
    pkgs = import nixpkgs {inherit system;};

  in {

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = import ./shell.nix
      { inherit pkgs defaultPackageName defaultPackage; };
  }) // ( let
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
