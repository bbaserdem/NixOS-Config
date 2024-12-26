# Language and keyboard settings
{pkgs, ...}: {
  home = {
    keyboard = {
      layout = "us,us";
      variant = "alt-intl,dvorak-altgr-intl";
      options = ["grp:alt_caps_toggle"];
    };
    language = {
      base = "en_US.UTF-8";
      collate = "en_US.UTF-8";
      name = "en_US.UTF-8";
    };
  };
}
