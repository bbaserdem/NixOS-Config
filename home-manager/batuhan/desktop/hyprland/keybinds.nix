# home-manager/batuhan/desktop/hyprland/keybinds/default.nix
# Keybindings entry point
{
  config,
  pkgs,
  ...
}: let
  # Binaries from config
  hyprshot = "${config.programs.hyprshot.package}/bin/hyprshot";
  kitty = "${config.programs.kitty.package}/bin/kitty";
  hyprpanel = "${config.programs.hyprpanel.package}/bin/hyprpanel";
  fuzzel = "${config.programs.fuzzel.package}/bin/fuzzel";
  # Binaries from pkgs
  # runapp = "${pkgs.unstable.runapp}/bin/runapp";  # Using uwsm app instead
  uwsm = "${pkgs.uwsm}/bin/uwsm";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in {
  # Enable hyprland
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    bind = [
      # WORKSPACES
      # Switch using numbers
      "$mainMod, 1, split:workspace, 1"
      "$mainMod, 2, split:workspace, 2"
      "$mainMod, 3, split:workspace, 3"
      "$mainMod, 4, split:workspace, 4"
      "$mainMod, 5, split:workspace, 5"
      "$mainMod, 6, split:workspace, 6"
      "$mainMod, 7, split:workspace, 7"
      "$mainMod, 8, split:workspace, 8"
      "$mainMod, 9, split:workspace, 9"
      "$mainMod, 0, split:workspace, 10"
      # Move active window to a workspace, and switch there
      "$mainMod ALT, 1, split:movetoworkspacesilent, 1"
      "$mainMod ALT, 2, split:movetoworkspacesilent, 2"
      "$mainMod ALT, 3, split:movetoworkspacesilent, 3"
      "$mainMod ALT, 4, split:movetoworkspacesilent, 4"
      "$mainMod ALT, 5, split:movetoworkspacesilent, 5"
      "$mainMod ALT, 6, split:movetoworkspacesilent, 6"
      "$mainMod ALT, 7, split:movetoworkspacesilent, 7"
      "$mainMod ALT, 8, split:movetoworkspacesilent, 8"
      "$mainMod ALT, 9, split:movetoworkspacesilent, 9"
      "$mainMod ALT, 0, split:movetoworkspacesilent, 10"
      # Move active window to a workspace without switching
      "$mainMod SHIFT, 1, split:movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, split:movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, split:movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, split:movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, split:movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, split:movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, split:movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, split:movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, split:movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, split:movetoworkspacesilent, 10"
      # Switch to next/previous workspace
      "$mainMod, N, split:workspace, m+1"
      "$mainMod SHIFT, N, split:workspace, m-1"
      # Scratchpad
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"
      # Reorg workspaces
      "$mainMod, D, split:swapactiveworkspaces, current r+1"
      "$mainMod SHIFT, D, split:grabroguewindows"
      # WINDOW MANAGEMENT
      "$mainMod, Q, killactive," # Closes window
      "$mainMod, F, togglefloating," # Makes floating window
      "$mainMod, P, pseudo," # Switch to pseudo-tiling
      # Split modifiers
      "$mainMod, Period,  layoutmsg, togglesplit," # Change split direction
      "$mainMod, Comma,   layoutmsg, swapsplit," # Swap windows in split
      "$mainMod, Quote,   layoutmsg, movetoroot unstable" # Bring to front
      # Preselect split
      "$mainMod ALT, left,  layoutmsg, preselect l"
      "$mainMod ALT, right, layoutmsg, preselect r"
      "$mainMod ALT, up,    layoutmsg, preselect u"
      "$mainMod ALT, down,  layoutmsg, preselect d"
      # Change window focus
      "$mainMod, left,  movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up,    movefocus, u"
      "$mainMod, down,  movefocus, d"
      # Move active window
      "$mainMod SHIFT, left,  movewindow, l"
      "$mainMod SHIFT, right, movewindow, r"
      "$mainMod SHIFT, up,    movewindow, u"
      "$mainMod SHIFT, down,  movewindow, d"
      # COMMANDS
      "$mainMod, Return,            exec, ${uwsm} app -- ${kitty}"
      "$mainMod, Space,             exec, ${uwsm} app -- ${fuzzel}"
      "$mainMod ALT SHIFT,  Escape, exec, ${uwsm} stop"
      "$mainMod,            Escape, exec, loginctl lock-session"
      # Screenshot
      "              , Print, exec, ${uwsm} app -- ${hyprshot} --mode active --mode output --filename \"$(hostname)_$(date +'%Y-%m-%d_%H-%M-%S')\""
      "         SHIFT, Print, exec, ${uwsm} app -- ${hyprshot} --mode active --mode output --clipboard-only"
      "$mainMod      , Print, exec, ${uwsm} app -- ${hyprshot} --mode region --filename \"$(hostname)_$(date +'%Y-%m-%d_%H-%M-%S')\""
      "$mainMod SHIFT, Print, exec, ${uwsm} app -- ${hyprshot} --mode region --clipboard-only"
      "ALT           , Print, exec, ${uwsm} app -- ${hyprshot} --mode window --filename \"$(hostname)_$(date +'%Y-%m-%d_%H-%M-%S')\""
      "ALT      SHIFT, Print, exec, ${uwsm} app -- ${hyprshot} --mode window --clipboard-only"
    ];
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    bindel = [
      ",XF86AudioRaiseVolume,   exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume,   exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute,          exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute,       exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp,    exec, ${brightnessctl} -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown,  exec, ${brightnessctl} -e4 -n2 set 5%-"
    ];
    bindl = [
      ", XF86AudioNext,         exec, ${playerctl} next"
      ", XF86AudioPause,        exec, ${playerctl} play-pause"
      ", XF86AudioPlay,         exec, ${playerctl} play-pause"
      ", XF86AudioPrev,         exec, ${playerctl} previous"
      ", XF86PowerOff,          exec, ${hyprpanel} toggleWindow powerdropdownmenu"
    ];
  };
}
