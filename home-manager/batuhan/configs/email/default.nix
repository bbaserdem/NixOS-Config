# Neomutt config
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./wolframite.nix
  ];
  
  # Global settings
  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";
  };

}
