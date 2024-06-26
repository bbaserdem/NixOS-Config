# Hyprland config in nix format
# Base16 is;
# 00-03 are dark to gray
# 04-07 are gray to white
{
  inputs,
  pkgs,
  config,
  ...
}: let
  # Functions to generate color and gradient strings
  rgba = {
    color,
    alpha ? "ff",
  }: "rgba(${color}${alpha})";
  grad = {
    color1,
    color2,
    alpha1 ? "ff",
    alpha2 ? "ff",
    degree ? "0",
  }: "rgba(${color1}${alpha1}) rgba(${color2}${alpha2}) ${degree}deg";
  # Color definitions for legibility
  black = config.colorScheme.palette.base00;
  background = config.colorScheme.palette.base01;
  selection_bg = config.colorScheme.palette.base02;
  comment = config.colorScheme.palette.base03;
  foreground = config.colorScheme.palette.base04;
  text = config.colorScheme.palette.base05;
  bright = config.colorScheme.palette.base06;
  white = config.colorScheme.palette.base07;
  red = config.colorScheme.palette.base08;
  orange = config.colorScheme.palette.base09;
  yellow = config.colorScheme.palette.base0A;
  green = config.colorScheme.palette.base0B;
  cyan = config.colorScheme.palette.base0C;
  indigo = config.colorScheme.palette.base0D;
  magenta = config.colorScheme.palette.base0E;
  brown = config.colorScheme.palette.base0F;
  # Transparency points
  opaque = "ff"; # 1
  solid = "e6"; # 0.9
  semi-transparent = "cd"; # 0.8
  half = "80"; # 0.5
  translucent = "40"; # 0.25
  tinge = "1a"; # 0.1
in {
  # HYPRLAND CONFIG
  wayland.windowManager.hyprland.settings = {
    # Keyboard input
    input = {
      # Use system wide layout
      kb_layout = config.home.keyboard.layout;
      kb_variant = config.home.keyboard.variant;
      kb_options = config.home.keyboard.options;
      # Use dvorak always
      resolve_binds_by_sym = false;
      # Touchpad
      scroll_method = "2fg";
      natural_scroll = false;
      touchpad = {
        disable_while_typing = true;
        natural_scroll = true;
        clickfinger_behavior = true;
        tap-to-click = true;
      };
      # Focus behavior
      follow_mouse = 1;
      mouse_refocus = true;
    };

    # Gestures
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_use_r = true;
      workspace_swipe_create_new = false;
    };

    # Look and Feel
    general = {
      # Layout
      layout = "dwindle";
      # Window borders
      border_size = 2;
      no_border_on_floating = false;
      resize_on_border = true;
      extend_border_grab_area = 5;
      "col.inactive_border" = rgba {color = red;};
      "col.active_border" = rgba {color = white;};
      "col.nogroup_border" = rgba {color = orange;};
      "col.nogroup_border_active" = rgba {color = yellow;};
      # Gaps
      gaps_in = 5;
      gaps_out = 20;
      gaps_workspaces = 0;
      # Cursor
      cursor_inactive_timeout = false;
      no_cursor_warps = true;
    };

    # Miscellaneous
    misc = {
      disable_hyprland_logo = true;
      force_default_wallpaper = 1;
      disable_splash_rendering = true;
    };

    # Window decorations
    decoration = {
      rounding = 2;
      # Shadow
      drop_shadow = true;
      shadow_range = 8;
      shadow_render_power = 2;
      "col.shadow" = rgba {
        color = black;
        alpha = translucent;
      };
      "col.shadow_inactive" = rgba {
        color = black;
        alpha = translucent;
      };
      # Dimming
      dim_inactive = true;
      active_opacity = 1.0;
      inactive_opacity = 0.9;
      fullscreen_opacity = 1.0;
      blur = {
        enabled = true;
        size = 12;
        passes = 3;
        new_optimizations = true;
        xray = true;
        contrast = 0.9;
        brightness = 0.8;
        popups = false;
      };
    };

    # Animations
    animations = {
      enabled = true;
      first_launch_animation = true;
    };

    # Debug stuff
    debug = {
      disable_logs = false;
    };
  };
}
