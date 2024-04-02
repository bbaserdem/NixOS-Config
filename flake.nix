# NixOS: flake.nix

{
  description = "Nixos config flake for Batuhan's OS installations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Partitioning manager
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Setup for impermanence
    impermanence.url = "github:nix-community/impermanence";
    # Color themes for entirety of nix
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { ... } @ inputs: let
    myLib = import ./myLib/default.nix {inherit inputs;};
  in with myLib; {

    nixosConfigurations = {
      umay      = mkSystem ./hosts/umay;
      #od-iyesi  = mkSystem ./hosts/od-iyesi;
      #yertengri = mkSystem ./hosts/yertengri;
      #su-iyesi  = mkSystem ./hosts/su-iyesi;
      #yel-ana   = mkSystem ./hosts/yel-ana;
    };

    homeConfigurations = {
      "batuhan@umay"      = mkHome "x86_64-linux" ./hosts/umay;
      #"batuhan@od-iyesi"  = mkHome "x86_64-linux" ./hosts/od-iyesi;
      #"batuhan@yertengri" = mkHome "x86_64-linux" ./hosts/yertengri;
      #"batuhan@su-iyesi"  = mkHome "x86_64-linux" ./hosts/su-iyesi;
      #"batuhan@yel-ana"   = mkHome "x86_64-linux" ./hosts/yel-ana;
    };

    homeManagerModules.default  = ./homeManagerModules;
    nixosModules.default        = ./nixosModules;

  };
}
