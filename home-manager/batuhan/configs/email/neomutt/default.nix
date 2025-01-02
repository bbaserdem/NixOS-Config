# Neomutt config
{
  lib,
  ...
}: {

  # Separate files for different things
  imports = [
    ./theme.nix
    ./mailcap.nix
    ./keybinds.nix
  ];

  # Neomutt config
  programs.neomutt = {
    enable = true;

    # General settings
    settings = {
      use_threads = "reverse";
      sort = "last-date";
      sort_aux = "date";
      narrow_tree = "yes";
      menu_scroll = "yes";
      edit_headers = "yes";
      empty_subject = "Mail";
      forward_format = "\"Fwd: %s\"";
    };
  };
}
