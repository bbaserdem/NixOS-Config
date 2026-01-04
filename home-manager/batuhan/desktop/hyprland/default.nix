# home-manager/batuhan/desktop/hyprland/default.nix
# Hyprland entry point
{
  config,
  pkgs,
  host,
  inputs,
  ...
}: {
  imports = [
    # External
    inputs.hyprdynamicmonitors.homeManagerModules.default
    # Internal
    ./monitors
    ./keybinds.nix
    ./autostart.nix
    ./idle.nix
    ./launcher.nix
    ./lock.nix
    ./plugins.nix
    ./settings.nix
    ./shell.nix
  ];

  # Styling
  stylix.targets.hyprland = {
    colors.enable = true;
    enable = true;
  };

  # Systemd fix for uwsm, and env variables for hyprland
  xdg.configFile = {
    # Systemd fix for uwsm
    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
    # Env vars for hyprland
    "uwsm/env-hyprland".text = ''
      export HYPRCURSOR_SIZE=24
      export QT_QPA_PLATFORMTHEME=qt6ct
      export QT_QPA_PLATFORM=wayland
      export QT_IM_MODULE="fcitx"
      export QT_IM_MODULES="wayland;fcitx;ibus"
      unset GTK_IM_MODULE
    '';
  };
  # Environment variables for hyprland

  # Enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
  };

  # Environment packages
  home.packages = with pkgs; [
    playerctl
    brightnessctl
    poweralertd
    # unstable.runapp  # Using uwsm app instead
  ];

  # Utilities
  programs = {
    # Screenshot utility
    hyprshot = {
      enable = true;
      saveLocation = "${config.xdg.userDirs.pictures}/Screenshots/${host}/";
    };
  };
}
