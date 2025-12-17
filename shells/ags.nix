# AGS v3 Development Shell
{
  pkgs,
  inputs,
  system,
  ...
}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    # AGS with full astal library support
    inputs.ags.packages.${system}.agsFull

    # Development tools
    typescript
    nodejs_22

    # Runtime dependencies for testing
    gtk4
    libadwaita
    glib
    gobject-introspection

    # Utilities for shell development
    fzf
    jq
    brightnessctl
    playerctl
    hyprpicker
  ] ++ [
    # Astal CLI tools
    inputs.astal.packages.${system}.notifd
  ];

  shellHook = ''
    echo "AGS v3 Development Environment"
    echo "Commands available:"
    echo "  ags --help          - Show AGS help"
    echo "  ags bundle app.ts   - Bundle your AGS app"
    echo "  ags run             - Run AGS with current config"
    echo "  notifd              - Notification daemon"
    echo ""
    echo "To get started:"
    echo "  mkdir ~/.config/ags && cd ~/.config/ags"
    echo "  ags init            - Initialize AGS config"
  '';
}
