# List of desktop integration modules
{
  pkgs,
  lib,
  ...
}: {
  # Some app modules
  imports = [
    # ./gnome.nix
    ./keyboard.nix
    ./xdg-paths.nix
  ];

  stylix.targets = {
    gtk = {
      enable = true;
      flatpakSupport.enable = true;
    };
    qt = {
      #enable = true;
    };
    kde = {
      enable = true;
    };
  };

  # qt = {
  #   enable = true;
  #   style.name = "kvantum";
  # };
  xdg.configFile = {
    "Kvantum/Gruvbox-Dark-Brown".source = "${pkgs.gruvbox-kvantum}/share/Kvantum/Gruvbox-Dark-Brown";
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=Gruvbox-Dark-Brown
    '';
  };

  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    gruvbox-kvantum
  ];
}
