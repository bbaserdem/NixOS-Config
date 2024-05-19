# Module that sets preferred x layout everywhere
{
  pkgs,
  lib,
  ...
}: {
  # Xserver keymap
  services.xserver = {
    layout = "us";
    xkbVariant = "dvorak";
  };
  # Console keymap
  console.keyMap = "dvorak";
}
