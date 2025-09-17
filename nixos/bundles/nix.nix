# Bundling nix related software
{
  pkgs,
  inputs,
  ...
}: {
  # Use nix-index to find execs
  programs.command-not-found.enable = true;

  # Nixpkgs config
  nixpkgs = {
    config = {
      allowUnfree = true;
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
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      auto-optimise-store = true;
    };
    extraOptions = ''
      # Development related settings
      keep-outputs = true
      keep-derivations = true
      # Include pipe operators
      # extra-experimental-features = pipe-operators ca-derivations
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
