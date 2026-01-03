# home-manager/batuhan/desktop/hyprland/keybinds/default.nix
# Keybindings entry point
{
  config,
  host,
  ...
}: {
  # Screenshot utility for hyprland
  programs.hyprshot = {
    enable = true;
    saveLocation = "${config.xdg.userDirs.pictures}/Screenshots/${host}/";
  };

  # Enable hyprland
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Applications
      "$mainMod, Return, exec, uwsm app -- kitty"
      # Launchers
      "$mainMod, Space, exec, uwsm app -- fuzzel"
      "$mainMod SHIFT, Space, exec, uwsm app -- fuzzel --dmenu"
      # Functionality
      "$mainMod, Escape, exec, loginctl lock-session"
      "$mainMod ALT SHIFT, Escape, exec, uwsm stop"
      # Screenshot
      "              , Print, exec, uwsm app -- hyprshot --mode active --mode output --filename \"$(hostname)_$(date +'%Y-%m-%d_%H-%M-%S')\""
      "         SHIFT, Print, exec, uwsm app -- hyprshot --mode active --mode output --clipboard-only"
      "$mainMod      , Print, exec, uwsm app -- hyprshot --mode region --filename \"$(hostname)_$(date +'%Y-%m-%d_%H-%M-%S')\""
      "$mainMod SHIFT, Print, exec, uwsm app -- hyprshot --mode region --clipboard-only"
      "ALT           , Print, exec, uwsm app -- hyprshot --mode window --filename \"$(hostname)_$(date +'%Y-%m-%d_%H-%M-%S')\""
      "ALT      SHIFT, Print, exec, uwsm app -- hyprshot --mode window --clipboard-only"
    ];
    # l: Want to still work if input is disabled
    # e: Repeatable
    bindel = [
      ",XF86AudioRaiseVolume,   exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume,   exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute,          exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute,       exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp,    exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown,  exec, brightnessctl -e4 -n2 set 5%-"
    ];
    bindl = [
      ", XF86AudioNext,         exec, playerctl next"
      ", XF86AudioPause,        exec, playerctl play-pause"
      ", XF86AudioPlay,         exec, playerctl play-pause"
      ", XF86AudioPrev,         exec, playerctl previous"
      ", XF86PowerOff,          exec, dms ipc powermenu open"
    ];
  };
}
