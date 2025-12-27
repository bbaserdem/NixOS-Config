# Audio scripts; standalone lossless conversion from wav to flac
{pkgs}: let
  nu = "${pkgs.nushell}/bin/nu";
  fuzzel = "${pkgs.fuzzel}/bin/fuzzel";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
in
  pkgs.writeTextFile {
    name = "fuzzel-window";
    executable = true;
    destination = "/bin/fuzzel-window";
    text = ''
      #!${nu}

      # The menu function
      def show_menu [] {
        ${fuzzel} --dmenu --index --log-level=none
      }

      # Get windows in current workspace
      def get_workspace_windows [] {
        let active_window = ${hyprctl} -j activewindow | from json
        ${hyprctl} -j clients | from json | where workspace.id == $active_window.workspace.id
      }

      # Chose between get_windows and get_workspace_windows
      let windows = get_workspace_windows | sort-by focusHistoryID

      # No need if there is only one window
      if ( $windows | length ) <= 1 {
        exit
      }

      # Capture the output of the menu
      let window_index = $windows | get title | to text | show_menu

      if $window_index != "" {

        let window = $windows | get ($window_index | into int)

        # Prepend address with "address:" to make it a valid address for hyprctl
        let window_address = $window.address | str replace -r '^' 'address:'
        let hyprctl_output = ${hyprctl} dispatch focuswindow $window_address
        if $hyprctl_output != "ok" and $hyprctl_output != "" {
          echo $hyprctl_output
        }
      }
    '';
  }
