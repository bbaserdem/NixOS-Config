# Module that configures grub
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.myNixOS;
  homeDir = "${config.users.users.${cfg.userName}.home}";
in {
  options.myNixOS = {
    displayManager.name = lib.mkOption {
      default = "gdm";
      description = "Display manager to use; (gdm|sddm)";
      type = lib.types.enum [
        "gdm"
        "sddm"
        "regreet"
        "dms-greeter"
      ];
    };
  };

  imports = [
    inputs.dms.nixosModules.greeter
  ];

  config = lib.mkMerge [
    # GDM config
    (lib.mkIf (cfg.displayManager.name == "gdm") {
      services.displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    })

    # SDDM config
    (lib.mkIf (cfg.displayManager.name == "sddm") {
      services.displayManager.sddm = {
        enable = true;
        theme = "sddm-astronaut-theme";
        enableHidpi = true;
        wayland.enable = true;
        settings = {
          General = {
            InputMethod = "qtvirtualkeyboard";
          };
        };
      };
      environment.systemPackages = with pkgs; [
        # The theme is in unstable only for now
        sddm-astronaut-blackHole
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
        kdePackages.qtsvg
      ];
    })

    # Greetd config
    (lib.mkIf (cfg.displayManager.name == "regreet") {
      stylix.targets.regreet = {
        colors.enable = true;
        cursor.enable = true;
        fonts.enable = true;
        icons.enable = true;
        image.enable = true;
        imageScalingMode.enable = true;
        enable = true;
      };
      programs.regreet = {
        enable = true;
      };
    })
    (lib.mkIf (cfg.displayManager.name == "dms-greeter") {
      programs.dankMaterialShell.greeter = {
        enable = true;
        compositor.name = "hyprland";
        configHome = homeDir;
        logs = {
          save = true;
          path = "/tmp/dms-greeter.log";
        };
      };
    })
  ];
}
