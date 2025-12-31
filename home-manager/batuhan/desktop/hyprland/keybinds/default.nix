# home-manager/batuhan/desktop/hyprland/keybinds/default.nix
# Keybindings entry point
{...}: {
  imports = [
    ./launchers.nix
    ./workspaces.nix
  ];

  # Enable hyprland
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    bind = [
      # Window management
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
    ];
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
