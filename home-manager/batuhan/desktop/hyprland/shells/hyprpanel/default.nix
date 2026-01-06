# home-manager/batuhan/desktop/hyprland/shells/hyprpanel/default.nix
# Hyprpanel configuration
{
  config,
  pkgs,
  lib,
  ...
}: let
  xdg-open = "${pkgs.xdg-utils}/bin/xdg-open";
  # runapp = "${pkgs.unstable.runapp}/bin/runapp";  # Using uwsm app instead
  uwsm = "${pkgs.uwsm}/bin/uwsm";
  kitty = "${config.programs.kitty.package}/bin/kitty";
  hyprpanel = "${config.programs.hyprpanel.package}/bin/hyprpanel";
in {
  # Lock screen
  imports = [
    ./lock.nix
  ];

  # Power menu
  wayland.windowManager.hyprland.settings.bindl = [
    ", XF86PowerOff, exec, ${hyprpanel} toggleWindow powerdropdownmenu"
  ];

  # Override systemd unit
  systemd.user.services.hyprpanel = {
    Install.WantedBy = lib.mkForce ["wayland-session@Hyprland.target"];
    Unit = {
      After = lib.mkForce ["wayland-session@Hyprland.target"];
      PartOf = lib.mkForce [
        "wayland-session@Hyprland.target"
        "tray.target"
      ];
    };
  };

  # Config
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = {
        font = {
          name = "Unifont";
          label = "Unifont";
          size = "1.0rem";
          weight = 500;
        };
        bar = {
          menus = {
            enableShadow = false;
            shadowMargins = "5px 5px";
          };
          floating = true;
          buttons = {
            enableBorders = true;
            borderSize = "0.05em";
            y_margins = "0.2em";
          };
          border = {
            location = "none";
            width = "0.1em";
          };
          enableShadow = true;
          margin_sides = "0.5em";
          outer_spacing = "0em";
        };
        notification.enableShadow = true;
        osd = {
          enable = true;
          orientation = "horizontal";
          location = "top";
          enableShadow = true;
        };
      };
      menus = {
        transition = "crossfade";
        media = {
          hideAuthor = false;
          displayTime = true;
          displayTimeTooltip = true;
        };
        clock = {
          weather.unit = "metric";
          time = {
            military = true;
            hideSeconds = true;
          };
        };
        dashboard = {
          stats.enable_gpu = true;
          directories = {
            right = {
              directory1.command = "${uwsm} app -- ${xdg-open} ${config.xdg.userDirs.documents}";
              directory2.command = "${uwsm} app -- ${xdg-open} ${config.xdg.userDirs.pictures}";
            };
            left = {
              directory3.command = "${uwsm} app -- ${xdg-open} ${config.xdg.userDirs.extraConfig.XDG_PROJECTS_DIR}";
              directory2.command = "${uwsm} app -- ${xdg-open} ${config.xdg.userDirs.videos}";
              directory1.command = "${uwsm} app -- ${xdg-open} ${config.xdg.userDirs.download}";
            };
          };
        };
        power = {
          lowBatteryNotification = true;
          logout = "${uwsm} exit";
        };
      };
      tear = false;
      scalingPriority = "hyprland";
      bar = {
        layouts = {
          "*" = {
            left = [
              "dashboard"
              "workspaces"
              "cpu"
              "ram"
              "cputemp"
              "storage"
            ];
            middle = [
              "clock"
              "media"
            ];
            right = [
              "systray"
              "volume"
              "microphone"
              "bluetooth"
              "network"
              "notifications"
              "hypridle"
              "battery"
              "power"
            ];
          };
        };
        customModules = {
          ram.label = true;
          storage = {
            paths = ["/"];
            label = true;
            labelType = "percentage";
            round = true;
          };
          weather.unit = "metric";
          worldclock.format = "%H:%M:%S %p %Z";
        };
      };
      terminal = kitty;
      notifications.showActionsOnHover = true;
    };
  };
}
