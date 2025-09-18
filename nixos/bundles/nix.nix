# Bundling nix related software
{
  pkgs,
  inputs,
  lib,
  arch,
  ...
}:
{
  # Use nix-index to find execs
  programs.command-not-found.enable = true;

  # Package manager config
  nix = {
    extraOptions = ''
      # Development related settings
      keep-outputs = true
      keep-derivations = true
      # Include pipe operators
      # extra-experimental-features = pipe-operators ca-derivations
    '';
    gc = {
      automatic = true;
      options = "--delete-older-than 60d";
    };
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      auto-optimise-store = true;
    };
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
// (lib.optionalAttrs (lib.hasSuffix "-linux" arch) {
  # Linux-specific configuration
  programs.nix-ld.enable = true;
  nix.gc.dates = "weekly";
})
// (lib.optionalAttrs (lib.hasSuffix "-darwin" arch) {
  # Darwin-specific configuration
  nix.enable = true;
  nix.gc.interval = [
    {
      Hour = 3;
      Minute = 15;
      Weekday = 7;
    }
  ];
})
