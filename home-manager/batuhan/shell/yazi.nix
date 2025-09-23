# Yazi config
{pkgs, ...}: {
  # Settings
  programs.yazi = {
    enable = true;
    settings = {
      mgr = {
        show_symlink = true;
      };
      preview = {
        wrap = "no";
      };
      opener = {
        play = [
          {
            run = "mpv \"$@\"";
            desc = "Play using mpv";
            orphan = true;
          }
        ];
        edit = [
          {
            run = "$EDITOR \"$@\"";
            desc = "Edit file";
            block = true;
          }
        ];
        open = [
          {
            run = "xdg-open \"$@\"";
            desc = "Open using XDG";
            for = "linux";
          }
        ];
      };
    };
  };
}
