# Neomutt keybinds
{
  pkgs,
  lib,
  ...
}: {
  programs.neomutt = {
    
    # VIM like bindings
    vimKeys = lib.mkForce true;

    # Extra bindings
    binds = [
      {   # Search functions
        map = [ "index" "pager" ];
        key = "/";
        action = "search";
      } {
        map = [ "index" ];
        key = "\\\\";
        action = "vfolder-from-query";
      } {
        map = [ "index" "pager" ];
        key = "?";
        action = "search-reverse";
      } {
        map = [ "index" "pager" ];
        key = "n";
        action = "search-next";
      } {
        map = [ "index" "pager" ];
        key = "N";
        action = "search-opposite";
      } { # Replying
        map = [ "index" "pager" ];
        key = "r";
        action = "reply";
      } {
        map = [ "index" "pager" ];
        key = "a";
        action = "group-reply";
      } {
        map = [ "pager" ];
        key = "l";
        action = "list-reply";
      } {
        map = [ "pager" ];
        key = "L";
        action = "list-reply";
      } { # Miscellaneous
        map = [ "pager" ];
        key = "\\Ch";
        action = "help";
      } {
        map = [ "compose" ];
        key = "p";
        action = "postpone-message";
      } {
        map = [ "index" ];
        key = "p";
        action = "recall-message";
      }
    ];

    # Extra macros
    macros = [
      {
        map = [ "index" "pager" "attach" "compose" ];
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
