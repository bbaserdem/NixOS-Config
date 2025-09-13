# Neomutt config
{pkgs, ...}: {
  home.packages = with pkgs; [
    # Email client
    thunderbird
  ];
}
