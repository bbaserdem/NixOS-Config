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
  # Custom pager; bat
  home.packages = with pkgs; [
    bat
  ];
  home.sessionVariables.MANPAGER = "sh -c 'col -bx | bat -l man -p'";
}
