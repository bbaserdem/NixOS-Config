# home-manager/batuhan/desktop/hyprland/launcher.nix
# Fuzzel; app launcher
{...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=14";
        icons-enabled = false;
        prompt = "";
        dpi-aware = "no";
        use-bold = false;
        inner-pad = 5;
        vertical-pad = 20;
        horizontal-pad = 20;
        minimal-lines = true;
      };
    };
  };
}
