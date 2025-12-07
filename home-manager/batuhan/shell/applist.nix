# Shell config
{pkgs, ...}: {
  # We want FZF for our fuzzy completion menu
  programs.fzf = {
    enable = true;
    package = pkgs.fzf;
  };
  stylix.targets.fzf.enable = true;

  # Smarter cd
  programs.zoxide = {
    enable = true;
    package = pkgs.zoxide;
  };

  home.packages = with pkgs; [
    skim # Commandline fuzzy finder
    tree # Directory display
  ];
}
