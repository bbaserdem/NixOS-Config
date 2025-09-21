# PC system configuration file.
{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ./console.nix
  ];

  # Set our network name
  networking.hostName = "od-ata";

  users.users = {
    # Establish my unprivileged user
    nixos = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      initialHashedPassword = "";
    };
    # Root password should be 0
    root.initialHashedPassword = "";
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
