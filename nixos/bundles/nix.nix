# Bundling nix related software
{
  pkgs,
  inputs,
  ...
}: {
  # This needs disabling for nix-index flake to work
  programs.command-not-found.enable = false;

  # Nixpkgs config
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };


  # Package manager config
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes"];
      auto-optimise-store = true;
    };
    extraOptions = ''
      # Development related settings
      keep-outputs = true
      keep-derivations = true
      # Include pipe operators
      extra-experimental-features = pipe-operators
    '';
  };

  # Allow library stuff
  programs.nix-ld.enable = true;

  # Nix helper utilities
  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    nvd
    sops
    nix-index
  ];
}
