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
      "$mainMod, Q, killactive,"
      "$mainMod, V, togglefloating,"
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
  };
}
