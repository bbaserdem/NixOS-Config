# NixOS: flake.nix

{
  description = "bbaserdem's NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

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
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Quick access to library functions, home-manager overrides
    lib = nixpkgs.lib // home-manager.lib;
    # Supported systems for your flake packages, shell, etc.
    systems = [ "x86_64-linux" ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    pkgsFor = lib.genAttrs systems (system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    });
    forAllSystems = f: lib.genAttrs systems (system: f pkgsFor.${system});
    # Templates for machine and user configs
    mkSystem = name:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/${name}
        ];
      };
    mkHome = sys: name: host:
      home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsFor.${sys};
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home/${name}/${host}.nix
        ];
      };
  in {
    inherit lib;
    
    nixosModule = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    #templates = import ./templates;

    overlays = import ./overlays {inherit inputs;};

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    #devShells = forAllSystems (system: import ./shell.nix nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

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
  };
}
