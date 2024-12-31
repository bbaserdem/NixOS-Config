# Neomutt config
{
  config,
  pkgs,
  ...
}: let
  colors = config.colorScheme.palette;
in {
  # Import system secrets
  sops.secrets = {
    "google/nsfw" = {};
    "google/spam" = {};
    "google/work" = {};
    "google/orig" = {};
  };
  programs.neomutt = {
    enable = true;
  };
}
