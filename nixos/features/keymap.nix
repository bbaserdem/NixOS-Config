# Module that sets preferred x layout everywhere
{
  pkgs,
  lib,
  ...
}: {
  # Xserver keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };
  # Console keymap
  console.keyMap = "dvorak";
}
