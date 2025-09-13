# Configuring SOPS so that the keys are in the location we want
{config, ...}: {
  # Entry point for sops settings
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.ssh/batuhan_age_keys.txt";
    defaultSopsFile = ./../secrets.yaml;
  };

  # Set environment variable so systemd can find it
  systemd.user.sessionVariables = {
    EDITOR = config.home.sessionVariables.EDITOR;
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.ssh/batuhan_age_keys.txt";
  };
  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.ssh/batuhan_age_keys.txt";
  };
}
