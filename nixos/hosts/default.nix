# Common configuration options for all the hosts
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  host,
  arch,
  ...
}: let
  cfg = config.myNixOS;
in {
  # NixOS options to add for configuration, these should mostly stay the same
  options.myNixOS = {
    userName = lib.mkOption {
      default = "batuhan";
      description = "Username for user";
    };

    userNixosSettings = lib.mkOption {
      default = {};
      description = "NixOS user settings";
    };

    userDesktop = lib.mkOption {
      default = null;
      description = "Default desktop session for default user";
    };
  };

  # Wanted modules
  imports = with inputs; [
    sops-nix.nixosModules.sops
    home-manager.nixosModules.home-manager
  ];

  # Nixos configuration
  config = lib.mkMerge [
    {
      # Nixpkgs options
      nixpkgs = {
        config = {
          allowUnfree = true;
        };
        overlays = [
          # My overlays
          outputs.overlays.additions
          outputs.overlays.modifications
          outputs.overlays.unstable-packages
        ];
      };

      # Default user with home-manager, this should be named batuhan
      programs.zsh.enable = true;
      users.users.${cfg.userName} =
        {
          isNormalUser = true;
          initialPassword = "12345";
          description = "Batuhan Baserdem";
          shell = pkgs.zsh;
          extraGroups = [
            "wheel"
            "networkmanager"
            "docker"
            "libvirtd"
            "libvirtd-qemu"
          ];
        }
        // cfg.userNixosSettings;
      # Add us to users that can use nix
      nix.settings.trusted-users = [
        cfg.userName
      ];
      # Home manager setup for default user
      home-manager = {
        useGlobalPkgs = true;
        useuserPackages = true;
        users = {
          "${cfg.userName}" = ../../home-manager/${cfg.userName}/${host}.nix;
        };
        extraSpecialArgs = {
          inherit inputs outputs host arch;
          user = cfg.userName;
        };
      };

      # Generalized Personal module toggles
      myNixOS = {
        # Bundles, I want these all in every PC
        bundles = {
          archives.enable = true;
          filesystems.enable = true;
          nix.enable = true;
          styling.enable = true;
          tools.enable = true;
          utils.enable = true;
        };

        # Features, we always want these
        consolefont.enable = true;
        fonts.enable = false; # Using with stylix
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
          # Password hashes
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

    # Conditionally set the default desktop session
    (lib.mkIf (cfg.userDesktop != null) {
      services.displayManager.defaultSession = cfg.userDesktop;
    })
  ];
}
