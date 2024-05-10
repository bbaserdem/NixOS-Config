# Common configuration options for all the hosts
{
  inputs,
  outputs,
  myLib,
  lib,
  config,
  pkgs,
  system,
  rootPath,
  ...
}: {
  # Nixpkgs options
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

  # Globally wanted modules
  imports = [
    inputs.sops-nix-nixosModules.sops
  ];

  # Generalized Personal module toggles
  myNixOS = {
    # Bundles
    bundles = {
      archives.enable = true;
      filesystems.enable = true;
      nix.enable = true;
      tools.enable = true;
      utils.enable = true;
    };
    # Services
    services = {
      sunshine.enable = false;
    };
    # Features
    zsh.enable = true;
  };
  
  # Nix settings
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
  };
  programs.nix-ld.enable = true;
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
