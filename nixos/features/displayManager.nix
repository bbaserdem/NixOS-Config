# Module that configures grub
{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myNixOS;
in {
  options.myNixOS.displayManager.name = lib.mkOption {
    default = "gdm";
    description = "Display manager to use; (gdm|sddm)";
    type = lib.types.enum [
      "gdm"
      "sddm"
    ];
  };

  config = lib.mkMerge [

    # GDM config
    (lib.mkIf (cfg.displayManager.name == "gdm") {
      services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    })

    # SDDM config
    (lib.mkIf (cfg.displayManager.name == "sddm") {
      services.displayManager.sddm = {
        enable = true;
        theme = "catppuccin";
        extraPackages = with pkgs; [
          catppuccin-sddm-corners
        ];
        enableHidpi = true;
        wayland.enable = true;
      };
    })
  ];
}
