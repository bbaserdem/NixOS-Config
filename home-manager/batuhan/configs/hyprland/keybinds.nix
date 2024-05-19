# Hyprland keybinds,
{
  inputs,
  pkgs,
  ...
}: let
  binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
  rawbind = binding " " "exec";
  mvfocus = binding "SUPER" "movefocus";
  ws = binding "SUPER" "workspace";
  resizeactive = binding "SUPER CTRL" "resizeactive";
  mvactive = binding "SUPER ALT" "moveactive";
  mvtows = binding "SUPER SHIFT" "movetoworkspace";
  # Binaries
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
in {
  wayland.windowManager.hyprland.settings = {
    # Key bind settings
    binds = {
      workspace_back_and_forth = true;
      allow_workspace_cycles = true;
    };

    bind =
      builtins.concatLists (
        # WS movements, generated from list; 1-based on keyboard, 0-based intern.
        builtins.genList (
          x: let
            wrs = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mod,       ${wrs}, workspace,       ${toString (x + 1)}"
            "$mod SHIFT, ${wrs}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10
      )
      ++ [
        # Behavior
        # Exit with ctrl-alt-shift-esc
        (binding "CTRL ALT SHIFT" "exit" "Escape" "")
        # Close window
        (binding "$mod" "killactive" "Q" "")
        # Float
        (binding "$mod" "togglefloating" "F" "")
        # Scratch pad
        (binding "$mod" "togglespecialworkspace" "S" "scratchpad")
        (binding "$mod SHIFT" "movetoworkspace" "S" "special:scratchpad")
        # Move through workspaces

        # Launch Terminal
        (binding "$mod" "exec" "Return" "$terminal")
        # App launcher
        (binding "$mod" "exec" "Space" "nwg-drawer")
      ];

    # Mouse resize/drag
    bindm = [
      (binding "$mod" "movewindow" "mouse:272" "")
      (binding "$mod" "resizewindow" "mouse:273" "")
    ];

    # Media and volume controls
    bindl = [
      (rawbind "XF86AudioPlay" "${playerctl} play-pause")
      (rawbind "XF86AudioStop" "${playerctl} pause")
      (rawbind "XF86AudioPause" "${playerctl} pause")
      (rawbind "XF86AudioPrev" "${playerctl} previous")
      (rawbind "XF86AudioNext" "${playerctl} next")
      (rawbind "XF86AudioMute" "${pactl} set-sink-mute   @DEFAULT_SINK@    toggle")
      (rawbind "XF86AudioMicMute" "${pactl} set-source-mute @DEFAULT_SOURCCE@ toggle")
    ];

    # Audio/brightness controls
    bindle = [
      (rawbind "XF86AudioRaiseVolume" "${pactl} set-sink-volume @DEFAULT_SINK@ +5%")
      (rawbind "XF86AudioLowerVolume" "${pactl} set-sink-volume @DEFAULT_SINK@ -5%")
      (rawbind "XF86MonBrightnessUp" "${brightnessctl} set +5%")
      (rawbind "XF86MonBrightnessDown" "${brightnessctl} set 5%-")
      (rawbind "XF86KbdBrightnessUp" "${brightnessctl} -d asus::kbd_backlight set +1")
      (rawbind "XF86KbdBrightnessDown" "${brightnessctl} -d asus::kbd_backlight set  1-")
    ];
  };
}
