# PC system configuration file.
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # External
    inputs.sops-nix.nixosModules.sops
    # Internal modules
    ./hardware-configuration.nix
    ./network.nix
    ./console.nix
    ./wireguard.nix
  ];

  # Apply our overlay
  nixpkgs.overlays = [
    outputs.overlays.additions
  ];

  # Set our network name
  networking.hostName = "od-ata";

  # Sops config
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
      "nixos/password-hash" = {
        neededForUsers = true;
      };
      "root/password-hash" = {
        neededForUsers = true;
      };
    }
  };

  users.users = {
    # Establish my unprivileged user
    nixos = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      hashedPasswordFile = config.sops.secrets."nixos/password-hash".path;
    };
    # Root password should be 0
    root.hashedPasswordFile = config.sops.secrets."root/password-hash".path;
  };

  security = {
    polkit.enable = true;
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  # Auto login to user
  services.getty.autologinUser = "nixos";

  # Will need passwords in /home/nixos/.ssh/authorized_keys
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Allow nix-copy to live system
  nix.settings.trusted-users = ["nixos"];

  # Timezone
  time.timeZone = "UTC";

  # Available packages
  environment.systemPackages = with pkgs; [
    tree
  ];

  # Stateless machine
  system.stateVersion = config.system.nixos.release;
}
