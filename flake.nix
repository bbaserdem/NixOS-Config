# NixOS: flake.nix
{
  description = "bbaserdem's NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # We want access to hardware fixes
    hardware.url = "github:nixos/nixos-hardware";

    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";

    # Nixifying themes
    nix-colors.url = "github:misterio77/nix-colors";
    stylix.url = "github:danth/stylix";

    # Nix user repository
    nur.url = "github:nix-community/NUR";

    # Sets up nix database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Automated disk partitioning, and mounting
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Eventually want to set up disk impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Eventually want to set up secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spell libraries
    vimspell-tr = {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/tr.utf-8.spl";
      flake = false;
    };
    vimspell-en = {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl";
      flake = false;
    };

    # Future desktop
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    # AGS: Aylur's GTK Shell
    ags.url = "github:Aylur/ags";

    # Matlab shell (unused as of graduating from CSHL)
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    # Import my library functions
    myLib = import ./myLib {
      inherit inputs;
      rootPath = ./.;
    };
    # Convenient shortcut for flake-utils
    utils = inputs.flake-utils.lib;
    # Let us use outputs immediately from flake
    inherit (self) outputs;
    # List of hosts that are already configured
    configuredHosts = myLib.configuredHosts;
  in utils.eachDefaultSystem (system: let pkgs = myLib.pkgsFor system; in {
    # Outputs that need a system definition, to be available on all systems
    # My custom packages, executed by `nix build .#<pkgname>`
    packages = pkgs;
    #legacyPackages = pkgs;
    # Dev shells for this flake
    devShells = import ./shell.nix {inherit pkgs; };
    # Formatter to use with nix fmt command
    formatter = pkgs.alejandra;
    # Checking functions, executed by `nix flake check`
    # checks = import ./checks {inherit pkgs; };
    # Custom applications, executed by `nix run .#<name>
    # apps = = import ./apps.nix {inherit pkgs; };
  }) // { 
    # Outputs that don't need system definition
  
    # My library functions
    lib = myLib;
    # Overlays to the package list, function of the form `final: prev: {};`
    overlays = import ./overlays {inherit inputs; };
    # My flake templates,
    templates = import ./templates {inherit inputs; };
    # Modules provided by this flake
    nixosModules = ./modules/nixos;
    homeManagerModules = ./modules/home-manager;

    # NixOS configurations
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = outputs.lib.mkSystems (
      (inputs.nixpkgs.lib.lists.forEach configuredHosts ({host, ...}: host))
      ++ [
        # WIP hostnames, once done put them in myLib
      ]
    );

    # Standalone home-manager configurations, mostly for batuhan
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = (
      outputs.lib.mkHomes (inputs.nixpkgs.lib.lists.forEach configuredHosts (
        { host, arch, ... }: { inherit host arch; user = "batuhan"; }
      )) ++ [
        # Put extra standalone HM configs with attrsets {host, arch, user} here
      ]
    );
  };
}
