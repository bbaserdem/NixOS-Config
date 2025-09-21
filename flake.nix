# NixOS: flake.nix
{
  description = "bbaserdem's NixOS configuration";

  inputs = {
    # ----- System Flakes ----- #
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nix user repository
    nur.url = "github:nix-community/NUR";
    # Flake utilities
    flake-utils.url = "github:numtide/flake-utils";
    # Hardware fixes
    hardware.url = "github:nixos/nixos-hardware";
    # Nix darwin
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Raspberry Pi
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

    # ----- Utilities ----- #
    # Automated disk partitioning, and mounting
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Secret deployment
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Nixcats for neovim management
    nixCats = {
      url = "github:bbaserdem/NixCats";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # Fan control for framework laptop
    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Fix applications on mac
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Eventually want to set up disk impermanence
    # TODO: Set this up
    impermanence.url = "github:nix-community/impermanence";

    # ----- Desktop ----- #
    # AGS: Aylur's GTK Shell
    ags.url = "github:Aylur/ags";
    # Declaratively manage plasma
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # ----- Flair and small functionality ----- #
    # Nixifying theming and styling
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    # Discord client
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    # Let us pass our outputs to relevant modules
    inherit self;
    inherit (self) outputs;

    # Import my library functions
    lib = import ./lib {inherit inputs outputs;};

    # Convenient shortcut for flake-utils
    utils = inputs.flake-utils.lib;

    # List of hosts that are already configured
    configuredHosts = [
      # {
      #   arch = utils.system.x86_64-linux;
      #   host = "umay";
      # }
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
      overlays = import ./overlays {inherit inputs outputs;};

      # My flake templates,
      templates = import ./templates;

      # Modules provided by this flake
      nixosModules = import ./modules/nixos {inherit inputs outputs;};
      homeManagerModules = import ./modules/home-manager {inherit inputs outputs;};

      # NixOS configurations
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        {
          od-ata = inputs.nixos-raspberrypi.lib.nixosSystemFull {
            specialArgs = {inherit inputs outputs;};
            modules = [
              ./nixos
              ./nixos/hosts/od-ata
            ];
          };
        }
        // (lib.mkConfiguredHost configuredHosts);

      # MacOS configurations
      # Available through darwin-rebuild --switch
      darwinConfigurations = {
        "su-ana" = inputs.nix-darwin.lib.darwinSystem {
          modules = [./nixos/hosts/su-ana];
          specialArgs = {
            inherit inputs outputs;
            arch = utils.system.aarch64-darwin;
            host = "su-ana";
          };
        };
      };

      # Standalone HM configurations
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations =
        {
          # Put standalone HM configs here
        }
        // (lib.mkConfiguredUser "batuhan" configuredHosts);
    };
}
