# bbaserdem's configuration

Personal configuration of my OSs.
Currently migrating from Archlinux to NixOS, but some archlinux stuff might remain here.

# WIP

[*] 📁 Modular and toggleable config
[ ] 🔒 Luks disk encryption with btrfs
[ ] 🖥️ Wayland desktop
[ ] 📃 Neovim setup using external plugin management
[ ] 🤫 Secrets

## Contents

- ** modules** Modularized NixOS config
  - [ home-manager](home-manager) Home manager config, standalone
  - [ nixos](nixos) Systemwide NixOS config
- [󱩊 hosts](nixos/hosts) Different systems, named after gods of Tengrism
  - [🤰 Umay](nixos/hosts/umay) Virtual box
  - [🔥 Od İyesi](nixos/hosts/od-iyesi) Live USB
  - [🌳 Yertengri](nixos/hosts/yertengri) Home PC
  - [🌊 Su İyesi](nixos/hosts/su-iyesi) Work computer
  - [🎐 Yel Ana](nixos/hosts/yel-ana) Laptop
  - [🧟 Erlik](nixos/hosts/erlik) Phone (Very future project)
- [ users](home-manager/users) Different users, named after themselves
  - [🔪👑 batuhan](home-manager/users/batuhan) My user account
  - [🧙🐭 joeysaur](home-manager/users/joeysaur) Husband's user account (future)

## Resources

### NixOS

My configuration is based on or uses the following resources.

* [sioodmy's dotfiles](https://github.com/sioodmy/dotfiles)
* [vimjoyer's configuration](https://github.com/vimjoyer/nixconf)
* [Misterio77's config](https://github.com/misterio77/nix-config),
  and their [starter config](https://github.com/Misterio77/nix-starter-configs).

### Archlinux

My archlinux setup is based on the following
[blog series](https://disconnected.systems/blog/archlinux-repo-in-aws-bucket).

### Neovim

Used multiple resources, and had many iterations of my configuration.
Here are a few resources I can pinpoint as essential for my configuration.

* [Neovim Starter Guide](https://www.youtube.com/watch?v=Co7gcSvq6jA) by vimjoyer.
