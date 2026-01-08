# home-manager/batuhan/desktop/hyprland/shells/noctalia/default.nix
# Noctalia shell config entry
{
  config,
  inputs,
  lib,
  ...
}: let
  noctalia-shell = "${config.programs.noctalia-shell.package}/bin/noctalia-shell";
  noctalia-lock = "${noctalia-shell} ipc call lockScreen lock";
  noctalia-session = "${noctalia-shell} ipc call sessionMenu toggle";
in {
  imports = [
    inputs.noctalia.homeModules.default
    ./settings.nix
  ];

  config = lib.mkIf (config.userConfig.hyprland.shell == "noctalia") {
    # Override the targets to hyprland
    systemd.user.services.noctalia-shell = {
      Unit = {
        After = lib.mkForce ["wayland-session@Hyprland.target"];
        PartOf = lib.mkForce [
          "wayland-session@Hyprland.target"
          "tray.target"
        ];
      };
      Install.WantedBy = lib.mkForce ["wayland-session@Hyprland.target"];
    };

    # Register us as the lock command
    services.hypridle.settings.general.lock_cmd = noctalia-lock;

    # Register the power menu with hyprland
    wayland.windowManager.hyprland.settings.bindl = [
      ", XF86PowerOff, exec, ${noctalia-session}"
    ];

    # Integrate generated themes, overriding stylix
    # programs.kitty.extraConfig = lib.mkOrder 2000 ''
    #   include ${config.xdg.configHome}/kitty/themes/noctalia.conf
    # '';
    wayland.windowManager.hyprland.extraConfig = lib.mkOrder 2000 ''
      source=${config.xdg.configHome}/hypr/noctalia/noctalia-colors.conf
    '';
    # programs.fuzzel.settings = {
    #   colors = lib.mkForce {};
    #   main.include = "${config.xdg.configHome}/fuzzel/themes/noctalia";
    # };

    # Configure noctalia shell
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
    };
  };
}
