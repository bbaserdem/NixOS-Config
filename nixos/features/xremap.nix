# Configuring fingerprint
{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Enable using Xremap through home manager
  hardware.uinput.enable = true;
  users.groups.uinput.members = [ config.myNixOS.userName ];
  users.groups.input.members = [ config.myNixOS.userName ];
}
