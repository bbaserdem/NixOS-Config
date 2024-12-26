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
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    #MANROFFOPT = "-c'";
  };
}
