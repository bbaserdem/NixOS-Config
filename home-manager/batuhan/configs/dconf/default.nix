# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  lib, 
  ...
}:
with lib.hm.gvariant;
{
  dconf.settings = {
    "desktop/ibus/general" = {
      use-system-keyboard-layout = true;
    };

    "desktop/ibus/general/hotkey" = {
      triggers = [];
    };

    "desktop/ibus/panel/emoji" = {
      hotkey = [ "<Control>period" ];
    };

    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };

    "org/gnome/desktop/datetime" = {
      automatic-timezone = false;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us+dvorak" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 5;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };

  };
}
