# Hyprland config in nix format
# Base16 is;
# 00-03 are dark to gray
# 04-07 are gray to white
{
  colors,
  ...
}: let
  # Functions to generate color and gradient strings
  rgba = {
    color,
    alpha ? "ff"
  }: "rgba(${col}${alpha})";
  grad = {
    color1,
    color2,
    alpha1 ? "ff",
    alpha2 ? "ff",
    degree ? "0"
  }: "rgba(${color1}${alpha1}) rgba(${color2}${alpha2}) ${degree}deg";
  # Color definitions for legibility
  black =         colors.base00;
  background =    colors.base01;
  selection_bg =  colors.base02;
  comment =       colors.base03;
  foreground =    colors.base04;
  text =          colors.base05;
  bright =        colors.base06;
  white =         colors.base07;
  red =           colors.base08;
  orange =        colors.base09;
  yellow =        colors.base0A;
  green =         colors.base0B;
  cyan =          colors.base0C;
  indigo =        colors.base0D;
  magenta =       colors.base0E;
  brown =         colors.base0F;
  # Transparency points
  opaque =            "ff"; # 1
  solid =             "e6"; # 0.9
  semi-transparent =  "cd"; # 0.8
  half =              "80"; # 0.5
  translucent =       "40"; # 0.25
  tinge =             "1a"; # 0.1
in {

  # Look and Feel (general)
  general = {
    # Layout
    layout = "master";
    # Window borders 
    border_size = 2;
    no_border_on_floating = false;
    resize_on_border = true;
    extend_border_grab_area = 5;
    "col.inactive_border" =       rgba { color = red;     };
    "col.active_border" =         rgba { color = white;   };
    "col.nogroup_border" =        rgba { color = orange;  };
    "col.nogroup_border_active" = rgba { color = yellow;  };
    # Gaps
    gaps_in = 5;
    gaps_out = 20;
    gaps_workspaces = 0;
    # Cursor
    cursor_inactive_timeout = false;
    no_cursor_warps = true;
  };

  # KEYBINDS

  # Define super key as main modifier key
  "$mod" = "SUPER";
  
  bind = [
    # Example: launch firefox
    "$mod, F, exec, firefox"
    # Example: launch screenshot
    ", Print, exec, grimblast copy area"
  ]
  # Define workspace movements
  ++ (
    builtins.concatLists (builtins.genList (
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
    10)
  );

}
