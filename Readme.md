# bbaserdem's configuration

Personal configuration of my NixOS and MacOS computers

# WIP

- [ ] 🍏 Darwin syncthing module
- [ ] 🍏 Darwin/Linux agnostic home-manager layout
- [ ] 🖥️ River desktop
- [ ] 📥 Email automation
- [ ] 📅 Calendar
- [ ]   Podcasts using podgrab

## TODOs

Starting Home Manager activation
Sanity checking Nix
This is a live run
Using Nix version: nix-env (Lix, like Nix) 2.93.0
System type: aarch64-darwin
Additional system types: 
Features: gc, signed-caches
System configuration file: /etc/nix/nix.conf
User configuration files: /Users/batuhan/.config/nix/nix.conf:/Users/batuhan/.nix-profile/etc/xdg/nix/nix.conf:/etc/profiles/per-user/batuhan/etc/xdg/nix/nix.conf:/run/current-system/sw/etc/xdg/nix/nix.conf:/nix/var/nix/profiles/default/etc/xdg/nix/nix.conf
Store directory: /nix/store
State directory: /nix/var/nix
Data directory: /nix/store/0vn9444lszwlxrg98krrpyfdl4hgdzy6-lix-2.93.0/share
Activation variables:
  oldGenPath undefined (first run?)
  newGenPath=/nix/store/lfkc6lvncinlmw9qch6s0zab70w0vygl-home-manager-generation
  genProfilePath=/Users/batuhan/.local/state/nix/profiles/home-manager
  newGenGcPath=/Users/batuhan/.local/state/home-manager/gcroots/new-home
  currentGenGcPath=/Users/batuhan/.local/state/home-manager/gcroots/current-home
  legacyGenGcPath=/nix/var/nix/gcroots/per-user/batuhan/current-home

### Darwin

- Use brew to install mac-media-key-forwarder, register it LaunchAgent, and configure for mpd.

## Contents

- ** modules** Modularized NixOS config
  - [ home-manager](home-manager) Home manager config, standalone
  - [ nixos](nixos) Systemwide NixOS config
- [󱩊 hosts](nixos/hosts) Different systems, named after gods of Tengrism
  - [🤰 Umay](nixos/hosts/umay) Virtual box
  - [🔥 Od Ata](nixos/hosts/od-ata) Home VPN
  - [🌳 Yertengri](nixos/hosts/yertengri) Home PC
  - [🌊 Su Ana](nixos/hosts/su-ana) Work computer (MacOS)
  - [🌊 Su Ata](nixos/hosts/su-ata) Work server
  - [🎐 Yel Ana](nixos/hosts/yel-ana) Laptop
  - [🧟 Erlik](nixos/hosts/erlik) Phone (Very future project)
- [ users](home-manager/users) Different users, named after themselves
  - [🔪👑 batuhan](home-manager/users/batuhan) My user account
  - [🧙🐭 joeysaur](home-manager/users/joeysaur) Husband's user account (future)

## Resources

### NixOS

My configuration was created based on, or uses, the following resources.

* [sioodmy's dotfiles](https://github.com/sioodmy/dotfiles)
* [vimjoyer's configuration](https://github.com/vimjoyer/nixconf)
* [Misterio77's config](https://github.com/misterio77/nix-config),
  and their [starter config](https://github.com/Misterio77/nix-starter-configs).

Installation command is the following from live USB;

```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode destroy,format,mount ./nixos/hosts/<HOST>/disk-layout.nix
sudo nixos-install --root /mnt --no-root-passwd --flake .#<HOST>
```

### Archlinux

My archlinux setup was based on the following
[blog series](https://disconnected.systems/blog/archlinux-repo-in-aws-bucket).

# Guide

## LUKS keys

To generate luks keys, I use the following command;
```
dd bs=512 count=4 if=/dev/random of=<FILE>.key iflag=fullblock
```

## GPG

### Encryption / Decryption

To create GPG encrypted/decrpyted files; I use the following

```
gpg --output <FILE>.gpg --encrypt --recipient <ID> <FILE>
gpg --output <FILE> --decrypt <FILE>.gpg
```

## Sops

I'm using [sops-nix](https://github.com/Mic92/sops-nix) to manage secrets.
The sops command to encrypt a binary file is the following;

```
sops -e <INPUT>.file > <OUTPUT>.key
```
