# PC system configuration file.
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: let
  nixosUser = "batuhan";
  sopsWgConfig = {
    sopsFile = ../secrets.yaml;
    mode = "600";
  };
in {
  imports = [
    # External
    inputs.sops-nix.nixosModules.sops
    inputs.disko.nixosModules.disko
    # Internal modules
    ./console.nix
    ./disk-layout.nix
    ./hardware-configuration.nix
    ./network.nix
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
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      generateKey = false;
    };
    secrets = {
      "${nixosUser}/password-hash" = {
        neededForUsers = true;
      };
      "root/password-hash" = {
        neededForUsers = true;
      };
      "wireguard/private/od-ata" = {};
      # Public wireguard keys
      "wireguard/preshared/od-ata/od-ata" = sopsWgConfig;
      "wireguard/preshared/od-ata/su-ana" = sopsWgConfig;
      "wireguard/preshared/od-ata/su-ata" = sopsWgConfig;
      "wireguard/preshared/od-ata/yel-ana" = sopsWgConfig;
      "wireguard/preshared/od-ata/yertengri" = sopsWgConfig;
      "wireguard/preshared/od-ata/umay" = sopsWgConfig;
      "wireguard/preshared/od-ata/erlik" = sopsWgConfig;
    };
  };

  users.users = {
    # Establish my unprivileged user
    # Password is my old router password
    "${nixosUser}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      # Old wifi password
      hashedPasswordFile = config.sops.secrets."${nixosUser}/password-hash".path;
    };
    # Improved version of old wifi password
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
  services.getty.autologinUser = "${nixosUser}";

  # Will need passwords in /home/${nixosUser}/.ssh/authorized_keys
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  nix.settings = {
    # Enable flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Allow nix-copy to live system
    trusted-users = ["${nixosUser}"];
  };

  # Timezone
  time.timeZone = "UTC";

  # Available packages
  environment.systemPackages = with pkgs; [
    tree
    git
  ];

  # Stateless machine
  system.stateVersion = config.system.nixos.release;
}
