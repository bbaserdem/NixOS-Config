# Language and keyboard settings 
{
  pkgs,
  ...
}: {
  home = {
    keyboard = {
      layout = "us,tr,us";
      variant = "dvorak-alt-intl,f,altgr-intl";
      options = [ "grp:alt_caps_toggle" ];
    };
    language = {
      base = "en_US.UTF-8";
      collate = "tr_TR.UTF-8";
      name = "tr_TR.UTF-8";
    };
  };
}
