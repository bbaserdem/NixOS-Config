# Configuring SOPS so that the key is in the location we want
{
  pkgs,
  config,
  ...
}: {
  # Set environment variable so systemd can find it
  systemd.user.sessionVariables = {
    EDITOR = config.home.sessionVariables.EDITOR;
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.ssh/batuhan_age_keys.txt";
  };
  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.ssh/batuhan_age_keys.txt";
  };
}
