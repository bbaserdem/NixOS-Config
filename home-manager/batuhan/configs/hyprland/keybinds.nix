# Hyprland keybinds,
# This is called by hyprland.nix
# Workspace movements, generated from list; 1-based on keyboard, 0-based intern.
builtins.concatLists (
  builtins.genList (
    x: let
      ws = let
        c = (x + 1) / 10;
      in
        builtins.toString (x + 1 - (c * 10));
    in [
      "$mod, ${ws}, workspace, ${toString (x + 1)}"
      "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
    ]
  )
  10
) ++ [
  # Launch Firefox
  "$mod, F, exec, firefox"
]
