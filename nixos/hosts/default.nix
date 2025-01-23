# Common configuration options for all the hosts
{
  inputs,
  outputs,
  ...
}: {
  # Nixpkgs options
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # My nixCats setup
      outputs.nixCats.overlays.default
    ];
  };

  # Globally wanted modules
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-index-database.nixosModules.nix-index
    outputs.nixCats.nixosModules.default
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
    shell.enable = true;
    locale.enable = true;
  };

  # Nix settings
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    # Need to provide $NIX_PATH for nixd (lsp)
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
  programs.nix-ld.enable = true;
  nixpkgs.config.allowUnfree = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
