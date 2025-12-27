# home-manager/batuhan/desktop/hyprland/idle.nix
# Hypridle config
{pkgs, ...}: let
  bctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in {
  services.hypridle = {
    enable = true;
    # Launch when the uwsm unit launches
    systemdTarget = "wayland-session@Hyprland.target";
    settings = {
      general = {
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        # UNPLUGGED
        {
          # 3:00 - Dim screen on idle
          timeout = 150;
          on-timeout = "systemd-ac-power || ${bctl} -s set 10";
          on-resume = "systemd-ac-power || ${bctl} -r";
        }
        {
          # 5:00 - Turn screen off
          timeout = 300;
          on-timeout = "systemd-ac-power || hyprctl dispatch dpms off";
          on-resume = "systemd-ac-power || (hyprctl dispatch dpms on && ${bctl} -r)";
        }
        {
          # 5:10 - Lock screen
          timeout = 310;
          on-timeout = "systemd-ac-power || loginctl lock-session";
        }
        {
          # 6:00 - Suspend
          timeout = 360;
          on-timeout = "systemd-ac-power || systemctl suspend";
        }
        # POWERED
        {
          # 10:00 - Display off
          timeout = 600;
          on-timeout = "systemd-ac-power && hyprctl dispatch dpms off";
          on-resume = "systemd-ac-power && (hyprctl dispatch dpms on && ${bctl} -r)";
        }
        {
          # 10:30 - Lock screen
          timeout = 630;
          on-timeout = "systemd-ac-power && loginctl lock-session";
        }
        {
          # 30:00 - Suspend
          timeout = 1800;
          on-timeout = "systemd-ac-power && systemctl suspend";
        }
      ];
    };
  };
}
