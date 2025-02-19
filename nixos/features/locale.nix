# Module that sets locale
{
  pkgs,
  lib,
  ...
}: {
  # Ibus entry
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      uniemoji
      m17n
    ];
  };
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_GB.UTF-8/UTF-8"
    "tr_TR.UTF-8/UTF-8"
    "en_DK.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LANGUAGE = "en_US";
    LC_ADDRESS = "en_US.UTF-8";
    LC_COLLATE = "tr_TR.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MEASUREMENT = "en_DK.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "en_DK.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_DK.UTF-8";
  };
}
