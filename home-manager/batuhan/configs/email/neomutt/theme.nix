# Themeing options for neomutt
{
  config,
  ...
}: {
  # Import as separate files
  xdg.configFile = {
    "neomutt/catppuccin.muttrc" = {
      enable = true;
      source = ./catppuccin.muttrc;
    };
    "neomutt/catppuccin-latte.muttrc" = {
      enable = true;
      source = ./catppuccin-latte.muttrc;
    };
  };

  # Source in neomuttrc
  programs.neomutt = {

    # Source color theme files
    extraConfig = "source ${config.xdg.configHome}/neomutt/catppuccin.muttrc";
    
    # Sidebar
    sidebar = {
      enable = true;
      format = "%B%?F? [%F]?%* %?N?%N/?%S";
      width = 30;
    };
    
    # Theming related settings
    settings = {
      sidebar_divider_char = " |";
      status_chars = " *%A";
      compose_format = "\"-- NeoMutt: Compose  [Approx. msg size: %l   Atts: %a]%>-\"";
      status_format = "\"───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───\"";
    };
  };
}