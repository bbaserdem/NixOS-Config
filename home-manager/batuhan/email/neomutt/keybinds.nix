# Neomutt keybinds
{pkgs, ...}: {
  programs.neomutt = {
    # VIM like bindings
    vimKeys = true;

    # Extra bindings
    binds = [
      {
        # Search functions
        map = ["index" "pager"];
        key = "\\Cj";
        action = "sidebar-next";
      }
      {
        map = ["index" "pager"];
        key = "\\Ck";
        action = "sidebar-prev";
      }
      {
        map = ["index" "pager"];
        key = "\\Ch";
        action = "sidebar-open";
      }
    ];

    # Extra macros
    macros = [
      {
        map = ["index" "pager" "attach" "compose"];
        key = "\\Cb";
        action = "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>";
      }
    ];
  };

  # Have to include urlscan to make this work
  home.packages = with pkgs; [
    urlscan
  ];
}
