# home-manager/batuhan/desktop/hyprland/keybinds/default.nix
# Keybindings entry point
{...}: {
  imports = [
    ./workspaces.nix
  ];

  # Enable hyprland
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, Q, exec, kitty"
      "$mainMod, C, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, V, togglefloating,"
      "$mainMod, R, exec, $menu"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, J, togglesplit, # dwindle"
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
    ];
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];
    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];
  };
}
