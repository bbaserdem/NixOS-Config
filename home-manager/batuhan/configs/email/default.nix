# Neomutt config
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./wolframite.nix
  ];

  # Primary account
  accounts.email.accounts.nsfw.primary = true;
  
  # Global settings
  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";
  };

}
