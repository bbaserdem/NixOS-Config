# Neomutt config
{
  pkgs,
  config,
  ...
}: {

  # Mailcap
  xdg.configFile = {
    "neomutt/mailcap" = {
      enable = true;
      text = ''
        text/html; ${pkgs.lynx}/bin/lynx -display_charset=utf-8 -dump %s; nametemplate=%s.html; copiousoutput
        text/*; more
      '';
    };

    # Theming
    "neomutt/dark-theme" = {
      enable = true;
      source = ./colors.dark;
    };
    "neomutt/light-theme" = {
      enable = true;
      source = ./colors.light;
    };
  };

  # Neomutt config
  programs.neomutt = {
    enable = true;

    # Theming
    extraConfig = "source ${config.xdg.configHome}/neomutt/dark-theme";

    # Sidebar
    sidebar = {
      enable = true;
      format = "%B%?F? [%F]?%* %?N?%N/?%S";
      width = 30;
    };

    # General settings
    settings = {
      use_threads = "reverse";
      sort = "last-date";
      sort_aux = "date";
      sidebar_divider_char = " |";
      status_chars = " *%A";
      narrow_tree = "yes";
      menu_scroll = "yes";
      mailcap_path = "${config.xdg.configHome}/neomutt/mailcap";
      #status_format = "───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───";
      compose_format = "-- NeoMutt: Compose  [Approx. msg size: %l   Atts: %a]%>-";
      edit_headers = "yes";
      empty_subject = "Mail";
      forward_format = "Fwd: %s";
    };

    # Keybinds
    vimKeys = true;
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

    # Macros
    macros = [
      {
        map = [ "index" "pager" "attach" "compose" ];
        key = "\\Cb";
        action = "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>";
      }
    ];
  };

  home.packages = with pkgs; [
    urlscan
    lynx
  ];
}