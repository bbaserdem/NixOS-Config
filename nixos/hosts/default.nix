# Common configuration options for all the hosts
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
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
  imports = [
    inputs.sops-nix.nixosModules.sops
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

      # Default user, this should be named batuhan, unless overriden
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

      # Generalized Personal module toggles
      myNixOS = {
        # Bundles, I want these all in every PC
        bundles = {
          archives.enable = true;
          filesystems.enable = true;
          nix.enable = true;
          tools.enable = true;
          utils.enable = true;
        };

        # Features, we always want these
        consolefont.enable = true;
        fonts.enable = true;
        grub.enable = true;
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
