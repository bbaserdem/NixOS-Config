# home-manager/batuhan/desktop/hyprland/monitors/default.nix
# Hyprland dynamic monitor configuration entry point
{
  config,
  inputs,
  ...
}: let
  outPath = "${config.xdg.configHome}/hypr/monitor.conf";
  hdmName = "hyprdynamicmonitors";
  confName = "hyprconfigs";
in {
  imports = [
    inputs.hyprdynamicmonitors.homeManagerModules.default
  ];

  # Enable hyprdynamicmonitors in hyprland
  wayland.windowManager.hyprland.settings.source = [
    #"${outPath}"
  ];

  home.hyprdynamicmonitors = {
    enable = true;
    extraFiles = {
      "${hdmName}/${confName}/generic" = ./generic.conf;
      "${hdmName}/${confName}/home-left" = ./home-left.conf;
      "${hdmName}/${confName}/home-right" = ./home-right.conf;
      "${hdmName}/${confName}/home" = ./home.conf;
      "${hdmName}/${confName}/yel-ana" = ./yel-ana.tmpl;
      "${hdmName}/${confName}/yel-ana_present" = ./yel-ana_present.tmpl;
      "${hdmName}/${confName}/yel-ana_home-left" = ./yel-ana_home-left.tmpl;
      "${hdmName}/${confName}/yel-ana_home-right" = ./yel-ana_home-right.tmpl;
    };
    config = ''
      [general]
      destination = "${outPath}"
      debounce_time_ms = 1500
      pre_apply_exec = "notify-send 'HyprDynamicMonitors' 'Switching profile ...'"
      post_apply_exec = "notify-send 'HyprDynamicMonitors' 'Profile applied'"

      [hot_reload_section]
      debounce_time_ms = 1000

      [fallback_profile]
      config_file = "${confName}/generic.conf"
      config_file_type = "static"

      [profiles.home-left]
      config_file = "${confName}/home-left.conf"
      config_file_type = "static"
      [[profiles.home-left.conditions.required_monitors]]
      description="Dell Inc. DELL U2723QE 945Q834"
      monitor_tag = "home-left"

      [profiles.home-right]
      config_file = "${confName}/home-right.conf"
      config_file_type = "static"
      [[profiles.home-right.conditions.required_monitors]]
      description="Dell Inc. DELL U3425WE B8KFV84"
      monitor_tag = "home-right"

      [profiles.home]
      config_file = "${confName}/home.conf"
      config_file_type = "static"
      [[profiles.home.conditions.required_monitors]]
      description="Dell Inc. DELL U2723QE 945Q834"
      monitor_tag = "home-left"
      [[profiles.home.conditions.required_monitors]]
      description="Dell Inc. DELL U3425WE B8KFV84"
      monitor_tag = "home-right"

      [profiles.yel-ana]
      config_file = "${confName}/yel-ana.tmpl"
      config_file_type = "template"
      [[profiles.yel-ana.conditions.required_monitors]]
      description = "BOE 0x0BCA"
      monitor_tag = "yel-ana"

      [profiles.yel-ana_present]
      config_file = "${confName}/yel-ana_present.tmpl"
      config_file_type = "template"
      [[profiles.yel-ana_present.conditions.required_monitors]]
      description = "BOE 0x0BCA"
      monitor_tag = "yel-ana"
      [[profiles.yel-ana_present.conditions.required_monitors]]
      description = "*"
      match_name_using_regex = true
      monitor_tag = "generic"

      [profiles.yel-ana_home-left]
      config_file = "${confName}/yel-ana_home-left.tmpl"
      config_file_type = "template"
      [[profiles.yel-ana_home-left.conditions.required_monitors]]
      description="BOE 0x0BCA"
      monitor_tag = "yel-ana"
      [[profiles.yel-ana_home-left.conditions.required_monitors]]
      description="Dell Inc. DELL U2723QE 945Q834"
      monitor_tag = "home-left"

      [profiles.yel-ana_home-right]
      config_file = "${confName}/yel-ana_home-right.tmpl"
      config_file_type = "template"
      [[profiles.yel-ana_home-right.conditions.required_monitors]]
      description="BOE 0x0BCA"
      monitor_tag = "yel-ana"
      [[profiles.yel-ana_home-right.conditions.required_monitors]]
      description="Dell Inc. DELL U3425WE B8KFV84"
      monitor_tag = "home-right"
    '';
  };
}
