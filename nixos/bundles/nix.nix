# Bundling nix related software
{
  pkgs,
  inputs,
  ...
}: {
  # This needs disabling for nix-index flake to work
  programs.command-not-found.enable = false;
  # Automatic garbage collection
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
    extraOptions = ''
      # Development related settings
      keep-outputs = true
      keep-derivations = true
      # Include pipe operators
      extra-experimental-features = pipe-operators
    '';
  };
  # Nix helper utilities
  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    nvd
    sops
    nix-index
  ];
}
