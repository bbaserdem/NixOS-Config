# Shell config
{pkgs, ...}: {
  home.packages = with pkgs; [
    skim # Commandline fuzzy finder
    tree # Directory display
  ];
}
