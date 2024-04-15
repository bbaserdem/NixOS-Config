# Module that sets consolefonts

{ pkgs, lib, ... }: {
  # Xserver keymap
  services.xserver = {
    layout = "us";
    xkbVariant = "dvorak";
  };
  # Console keymap
  console.keyMap = "dvorak";
}
