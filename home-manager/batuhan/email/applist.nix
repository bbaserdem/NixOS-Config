# Neomutt config
{config, ...}: {
  home.packages = with pkgs; [
    # Email client
    thunderbird
  ];
}
