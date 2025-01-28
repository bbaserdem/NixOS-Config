# NixOS: flake.nix
let
  osVersion = "24.11";
in {
  description = "bbaserdem's NixOS configuration";

  inputs = {
    # ----- System Flakes ----- #
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-${osVersion}";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-${osVersion}";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nix user repository
    nur.url = "github:nix-community/NUR";
    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
    # Hardware fixes
    hardware.url = "github:nixos/nixos-hardware";

    # ----- Utilities ----- #
    # Automated disk partitioning, and mounting
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Sets up nix database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secret deployment
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nixcats for neovim management, might bud this off to another repo later
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    # Eventually want to set up disk impermanence
    # TODO: Set this up
    impermanence.url = "github:nix-community/impermanence";

    # ----- Desktop ----- #
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
    # Declaratively managing plasma
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # ----- Flair and small functionality ----- #
    # Nixifying themes
    nix-colors.url = "github:misterio77/nix-colors";
    stylix = {
      url = "github:danth/stylix/release-${osVersion}";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    # Let us pass out outputs to relevant modules
    inherit (self) outputs;

    # Import my library functions
    lib = import ./lib {inherit inputs outputs;};

    # Convenient shortcut for flake-utils
    utils = inputs.flake-utils.lib;

    # List of hosts that are already configured
    configuredHosts = [
      {
        arch = utils.system.x86_64-linux;
        host = "umay";
      }
      {
        arch = utils.system.x86_64-linux;
        host = "yertengri";
      }
      {
        arch = utils.system.x86_64-linux;
        host = "yel-ana";
      }
    ];
  in
    utils.eachDefaultSystem (system: let
      pkgs = lib.pkgsFor system;
    in {
      # Outputs that need a system definition, to be available on all systems

      # My custom packages, executed by `nix build .#<pkgname>`
      packages = import ./pkgs {inherit pkgs;};
      #legacyPackages = import ./pkgs {inherit pkgs;};

      # Dev shells for this flake
      devShells = import ./shells {inherit pkgs inputs system;};

      # Formatter to use with nix fmt command
      formatter = pkgs.alejandra;

      # Checking functions, executed by `nix flake check`
      # checks = import ./checks {inherit pkgs; };

      # Custom applications, executed by `nix run .#<name>
      # apps = = import ./apps.nix {inherit pkgs; };
    })
    // {
      # Outputs that don't need system definition

      # My library functions
      inherit lib;

      # Overlays to the package list, function of the form `final: prev: {};`
      overlays = import ./overlays {inherit inputs;};

      # My flake templates,
      templates = import ./templates;

      # Modules provided by this flake
      nixosModules = import ./modules/nixos {inherit inputs outputs;};
      homeManagerModules = import ./modules/home-manager {inherit inputs outputs;};

      # NixOS configurations
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        {
          # WIP hostnames, once done, put them in the <let in>
        }
        // (lib.mkConfiguredHost configuredHosts);

      # Standalone HM configurations
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations =
        {
          # Put standalone HM configs here
        }
        // (lib.mkConfiguredUser "batuhan" configuredHosts);

      # Nixcats outputs
      nixCats = import ./nixCats {inherit inputs outputs;};
    };
}
