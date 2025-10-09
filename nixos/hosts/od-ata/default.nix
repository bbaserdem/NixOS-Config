# PC system configuration file.
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: let
  nixosUser = "batuhan";
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
    # ./wireguard.nix  # Temporarily disabled to fix systemd-networkd
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
      "wireguard/public/od-ata" = {};
      "wireguard/public/su-ana" = {};
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
      hashedPasswordFile = config.sops.secrets."${nixosUser}/password-hash".path;
    };
    # Root password should also be done
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

  # Will need passwords in /home/nixos/.ssh/authorized_keys
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  # Allow nix-copy to live system
  nix.settings.trusted-users = ["${nixosUser}"];

  # Timezone
  time.timeZone = "UTC";

  # Available packages
  environment.systemPackages = with pkgs; [
    tree
  ];

  # Stateless machine
  system.stateVersion = config.system.nixos.release;
}
