# List of userspace applications
{inputs, ...}: {
  # Some app modules
  imports = [
    inputs.nixCats.homeManagerModules.default
    inputs.nixcord.homeModules.nixcord
    ./applist.nix
    ./discord.nix
    ./firefox.nix
    ./foliate.nix
    ./kitty.nix
    ./mangohud.nix
    ./neovim.nix
    ./newsboat.nix
    ./obsidian.nix
    ./remmina.nix
    ./syncthing.nix
    ./udiskie.nix
    ./virt-manager.nix
    ./zathura.nix
  ];
}
