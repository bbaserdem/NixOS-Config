# File to setup the default user
{
  lib,
  config,
  inputs,
  outputs,
  myLib,
  pkgs,
  rootPath,
  ...
}: let
  cfg = config.myNixOS;
in {
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
      default = "gnome";
      description = "Default desktop session for default user";
    };
  };

  config = {
    programs.zsh.enable = true;

    services.displayManager.defaultSession = cfg.userDesktop;

    users.users.${cfg.userName} =
      {
        isNormalUser = true;
        initialPassword = "12345";
        description = cfg.userName;
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
  };
}
