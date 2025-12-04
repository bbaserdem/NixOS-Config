# Module that configures grub
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myNixOS;
in {
  options.myNixOS = {
    displayManager.name = lib.mkOption {
      default = "gdm";
      description = "Display manager to use; (gdm|sddm)";
      type = lib.types.enum [
        "gdm"
        "sddm"
        "greetd"
      ];
    };
    displayManager.greetdProvider = lib.mkOption {
      default = null;
      description = "Greetd provider";
      type = lib.types.nullOr lib.types.enum [
        "wlgreet"
        "tuigreet"
        "regreet"
        "qtgreet"
        "gtkgreet"
      ];
    };
  };

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
    (lib.mkIf (cfg.displayManager.name == "qtgreet") (lib.mkMerge [
      {
        # Unconditional
        services.greetd = {
          enable = true;
          vt = 1;
          restart = true;
        };
      }
      (lib.mkIf (cfg.displayManager.greetdProvider == "qtgreet") {
        services.greetd.settings = {
          default_session = {
            command = "${pkgs.greetd.qtgreet} --cmd sway";
          };
        };
      })
    ]))
  ];
}
