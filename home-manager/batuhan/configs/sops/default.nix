# Configuring SOPS so that the key is in the location we want
{
  pkgs,
  ...
}: {
  # Set environment variable so systemd can find it
  systemd.user.sessionVariables = {
    EDITOR = "nvim";
    SOPS_AGE_KEY_FILE = "~/.ssh/batuhan_age_keys.txt";
  };
  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "~/.ssh/batuhan_age_keys.txt";
  };
}
