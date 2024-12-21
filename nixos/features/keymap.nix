# Module that sets preferred x layout everywhere
{
  pkgs,
  lib,
  ...
}: {
  # Xserver keymap
  services.xserver.xkb = {
    layout = "us,tr,us";
    variant = "dvorak-alt-intl,f,altgr-intl";
    options = "grp:alt_caps_toggle";
  };
  # Console keymap
  console.keyMap = "dvorak";
}
