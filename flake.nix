# NixOS: flake.nix

{
  description = "bbaserdem's NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # We want access to hardware fixes
    hardware.url = "github:nixos/nixos-hardware";

    # Nixifying themes
    nix-colors.url = "github:misterio77/nix-colors";

    # Eventually will use disko to declore partitioning 
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Firefox addons from NUR
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Eventually want to set up disk impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Eventually want to set up secrets
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Future desktop
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.nixpkgs.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      myLib = import ./myLib/default.nix {inherit inputs; rootPath = ./.;};
      inherit (self) outputs;
      config = nixpkgs.config;
    in with myLib; {
      # Custom packages
      packages = forAllSystems (
        system: import ./pkgs nixpkgs.legacyPackages.${system}
      );
      # Formatter to use with nix fmt command
      formatter = forAllSystems (
        system: nixpkgs.legacyPackages.${system}.alejandra
      );
      # Overlays to the package list
      overlays = import ./overlays { inherit inputs myLib config; };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        umay      = mkSystem "umay";
        #od-iyesi  = mkSystem "od-iyesi";
        #yertengri = mkSystem "yertengri";
        #su-iyesi  = mkSystem "su-iyesi";
        #yel-ana   = mkSystem "yel-ana";
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "batuhan@umay"      = mkHome "x86_64-linux" "batuhan" "umay";
        #"batuhan@od-iyesi"  = mkHome "x86_64-linux" "batuhan" "od-iyesi";
        #"batuhan@yertengri" = mkHome "x86_64-linux" "batuhan" "yertengri";
        #"batuhan@su-iyesi"  = mkHome "x86_64-linux" "batuhan" "su-iyesi";
        #"batuhan@yel-ana"   = mkHome "x86_64-linux" "batuhan" "yel-ana";
      };

      # Module directories
      nixosModules.default = ./nixosModules;
      homeManagerModules.default = ./homeManagerModules;
    };
}
