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
    myLib = import ./myLib/default.nix {
      inherit inputs;
      rootPath = ./.;
    };
    inherit (self) outputs;
  in
    with myLib; {
      # Custom packages
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Development shells
      devShells = forAllSystems (system: import ./shell.nix nixpkgs.legacyPackages.${system});
      # Formatter to use with nix fmt command
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
      # Overlays to the package list
      overlays = import ./overlays {inherit inputs; };

      # Module directories
      nixosModules.default = ./modules/nixos;
      homeManagerModules.default = ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        umay = mkSystem "umay";
        #od-iyesi  = mkSystem "od-iyesi";
        yertengri = mkSystem "yertengri";
        #su-iyesi  = mkSystem "su-iyesi";
        yel-ana = mkSystem "yel-ana";
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "batuhan@umay" = mkHome "x86_64-linux" "batuhan" "umay";
        #"batuhan@od-iyesi"  = mkHome "x86_64-linux" "batuhan" "od-iyesi";
        "batuhan@yertengri" = mkHome "x86_64-linux" "batuhan" "yertengri";
        "joeysaur@yertengri" = mkHome "x86_64-linux" "joeysaur" "yertengri";
        #"batuhan@su-iyesi"  = mkHome "x86_64-linux" "batuhan" "su-iyesi";
        "batuhan@yel-ana" = mkHome "x86_64-linux" "batuhan" "yel-ana";
      };
    };
}
