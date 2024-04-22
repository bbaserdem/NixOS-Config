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
        "completion"
        "match_prev_cmd"
      ];
    };
    enableCompletion = true;
    enableBashCompletion = true;
  };
  # Let zsh find system-based apps
  environment.pathsToLink = [ "/share/zsh" ];
}
