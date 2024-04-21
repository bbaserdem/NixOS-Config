# Module that enables a default zsh shell

{ pkgs, lib, ... }: {
  # Enable xserver so that SDDM can be run
  programs.zsh = {
    enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "root"
      ];
      styles = {
        "root" = "fg=red,bold";
      };
    };
    autosuggestions = {
      enable = true;
      strategy = [
        "match_prev_cmd"
        "completion"
      ];
    };
    enableCompletion = true;
    enableBashCompletion = true;
  };
}
