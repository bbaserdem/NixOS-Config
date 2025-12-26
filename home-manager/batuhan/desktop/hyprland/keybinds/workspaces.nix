# home-manager/batuhan/desktop/hyprland/keybinds/workspaces.nix
# Workspace movements
{...}: {
  wayland.windowManager.hyprland.settings = {
    bind = [
      "$mainMod, 1, split:workspace, 1"
      "$mainMod, 2, split:workspace, 2"
      "$mainMod, 3, split:workspace, 3"
      "$mainMod, 4, split:workspace, 4"
      "$mainMod, 5, split:workspace, 5"
      "$mainMod, 6, split:workspace, 6"
      "$mainMod, 7, split:workspace, 7"
      "$mainMod, 8, split:workspace, 8"
      "$mainMod, 9, split:workspace, 9"
      "$mainMod, 0, split:workspace, 10"

      "$mainMod SHIFT, 1, split:movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, split:movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, split:movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, split:movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, split:movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, split:movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, split:movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, split:movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, split:movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, split:movetoworkspacesilent, 10"

      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      "$mainMod, mouse_down, split:workspace, m+1"
      "$mainMod, mouse_up, split:workspace, m-1"

      # Reorg workspaces
      "$mainMod, D, split:swapactiveworkspaces, current r+1"
      "$mainMod SHIFT, D, split:grabroguewindows"
    ];
  };
}
