# Configuring man pages
{
  config,
  pkgs,
  ...
}: {
  # Enable home-manager man page
  manual.manpages.enable = true;

  # Enable man pages
  programs.man = {
    enable = true;
    generateCaches = true;
  };

  # Configure bat in our user
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      prettybat
      batwatch
      batpipe
      batman
      batgrep
      batdiff
    ];
  };
  # Enable color for bat
  stylix.targets.bat.enable = true;

  # Pager setting
  home.sessionVariables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c'";
  };
}
