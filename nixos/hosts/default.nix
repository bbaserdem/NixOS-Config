# Common configuration options for all the hosts
{
  inputs,
  outputs,
  ...
}: {
  # Nixpkgs options
  nixpkgs = {
    overlays = [
      # My overlays
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      # Flake overlays
      inputs.nixCats.overlays.default
    ];
  };

  # Globally wanted modules
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nix-index-database.nixosModules.nix-index
    inputs.nixCats.nixosModules.default
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

  # Sops, global key path
  sops = {
    defaultSopsFile = ./secrets.yaml;
    gnupg.sshKeyPaths = [];
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_all_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      generateKey = false;
    };
    secrets = {
      "batuhan/password-hash" = {
        neededForUsers = true;
      };
      "joeysaur/password-hash" = {
        neededForUsers = true;
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
