# List of userspace applications
{
  pkgs,
  lib,
  ...
}: {
  # Some app modules
  imports = [
    inputs.nixCats.homeManagerModules.default
    inputs.nixcord.homeModules.nixcord
    ./applist.nix
    ./discord.nix
    ./firefox.nix
    ./kitty.nix
    ./neovim.nix
    ./newsboat.nix
    ./remmina.nix
    ./syncthing.nix
    ./udiskie.nix
    ./virt-manager.nix
    ./zathura.nix
  ];
}
