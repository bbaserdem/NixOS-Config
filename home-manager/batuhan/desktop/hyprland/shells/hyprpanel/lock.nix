# home-manager/batuhan/desktop/hyprland/lock.nix
# Hyprlock config
{
  pkgs,
  config,
  lib,
  ...
}: let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  sed = "${pkgs.gnused}/bin/sed";
  playerStatusScript = pkgs.writeShellScriptBin "hyprlock-player-status" ''
    escape_pango() {
      ${sed} -e 's/&/\&amp;/g' \
          -e 's/</\&lt;/g' \
          -e 's/>/\&gt;/g'
    }

    player_name=$(${playerctl} metadata --format '{{playerName}}')
    player_status=$(${playerctl} status)

    if [[ "$player_status" == "Playing" ]]; then
      song_info=$(${playerctl} metadata --format '󰎇 {{title}} {{artist}}')
    fi

    if [[ "$player_status" == "Paused" ]]; then
      song_info=$(${playerctl} metadata --format ' {{title}} {{artist}}')
    fi

    echo "$player_name :$song_info" | escape_pango
  '';
  hyprlockPlayerStatus = "${playerStatusScript}/bin/hyprlock-player-status";
in {
  config = lib.mkIf (config.userConfig.hyprland.shell == "hyprpanel") {
    # Styling
    stylix.targets.hyprlock = {
      enable = true;
      colors.enable = true;
      image.enable = true;
      useWallpaper = true;
    };

    # Register us as the lock command
    services.hypridle.settings.general.lock_cmd = "${config.programs.hyprlock.package}/bin/hyprlock";

    # Configure hyprlock
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          immediate_render = true;
          transparent = true;
          hide_cursor = false;
          ignore_empty_input = true;
        };

        animation- = {
          enabled = true;
          fade_in = {
            duration = 300;
            bezier = "easeOutQuint";
          };
          fade_out = {
            duration = 300;
            bezier = "easeOutQuint";
          };
        };

        background = {
          monitor = "";
          blur_passes = 3;
          blur_size = 8;
          brightness = 0.3;
        };

        # Password field
        input-field = {
          monitor = "";

          size = "20%, 5%";
          position = "0, -468";
          outline_thickness = 0;
          halign = "center";
          valign = "center";

          dots_size = 0.25;
          dots_spacing = 0.55;
          dots_center = true;
          dots_rounding = -1;

          fade_on_empty = false;
          rounding = 15;

          font_family = "Monospace";
          placeholder_text = "";
          fail_text = "$FAIL ($ATTEMPTS)";
        };

        label = [
          {
            # Music
            monitor = "";
            text = "cmd[update:1000] ${hyprlockPlayerStatus}";
            color = config.programs.hyprlock.settings.input-field.font_color;
            font_size = 16;
            font_family = "Monospace";
            position = "0, -30";
            halign = "center";
            valign = "top";
          }
          {
            # Date
            monitor = "";
            text = "cmd[update:1000] echo \"$(date +\"%A, %d %B %Y\")\"";
            color = config.programs.hyprlock.settings.input-field.font_color;
            font_size = 20;
            font_family = "Sans";
            position = "0, 405";
            halign = "center";
            valign = "center";
          }
          {
            # Time
            monitor = "";
            text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
            color = config.programs.hyprlock.settings.input-field.font_color;
            font_size = 93;
            font_family = "Sans";
            position = "0, 310";
            halign = "center";
            valign = "center";
          }
          {
            # User
            monitor = "";
            text = "$USER";
            color = config.programs.hyprlock.settings.input-field.font_color;
            font_size = 16;
            font_family = "Sans";
            position = "0, 30";
            halign = "center";
            valign = "bottom";
          }
        ];
      };
    };
  };
}
