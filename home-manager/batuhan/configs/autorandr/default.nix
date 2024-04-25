# Autorandr config
{
  pkgs,
  lib,
  ...
}: let
  edid = import ./edid-list.nix;
in {
  # Enable autorandr systemd service
  services.autorandr.enable = lib.mkDefault true;
  # Autorandr configuration
  programs.autorandr = {
    enable = true;
    hooks = {
      postswitch = {
        message = ''
          notify-send \
            "Autorandr" \
            "Changed layout to ''${AUTORANDR_CURRENT_PROFILE}" \
            --icon=display
        '';
      };
    };
    profiles = {
      "Home" = {
        fingerprint.HDMI-A-0 = edid.home-monitor;
        config.HDMI-A-0 = {
          mode = "3840x2160";
          position = "0x0";
          rate = "60.00";
          primary = true;
        };
      };
      "Laptop" = {
        fingerprint.eDP-1 = edid.laptop-screen;
        config.eDP-1 = {
          mode = "1920x1080";
          position = "0x0";
          primary = true;
        };
      };
      "Laptop-Work" = {
        fingerprint.DP-1 = edid.work-monitor;
        config.DP-1 = {
          mode = "3440x1440";
          position = "0x0";
          primary = true;
        };
      };
      "Laptop-Work-Dual" = {
        fingerprint = {
          DP-1 = edid.work-monitor;
          eDP-1 = edid.laptop-screen;
        };
        config = {
          DP-1 = {
            mode = "3440x1440";
            position = "0x0";
            primary = true;
          };
          eDP-1 = {
            mode = "1920x1080";
            position = "3440x180";
          };
        };
      };
      "Laptop-Present" = {
        fingerprint = {
          DP-1 = "*";
          eDP-1 = edid.laptop-screen;
        };
        config = {
          eDP-1 = {
            mode = "1920x1080";
            position = "0x0";
            primary = true;
          };
          DP-1 = {
            mode = "1920x1080";
            position = "1920x0";
          };
        };
      };
    };
  };
}
