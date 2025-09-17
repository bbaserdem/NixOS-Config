# Su Ata

`Su Ata` means *water ancestor*, masculine personification of water.
This server is meant as headless, and contain compute resources.

# Services

- **SSH**: Remote access to machine
- **Syncthing**: Better file syncing tool over rsync etc.
- **Jupyter Lab**: Access local development, beyond text editors.
- **Traefik Web Server**: Dashboard with access to systems.

## Setup

* Firewall
* SSH
* CUDA
* Traefik
* SSL
* Syncthing
* Jupyter Lab
* Custom landing page
* Python kernel discovery 
* System metrics

# Disk Layout

The disk layout is shown below <WIP>

```
<Partition:label>               <fs>    <Label>         <Size>  <Mountpoint>
│                               GPT                         TiB
├─p1:Su-Ata_ESP                 exfat   Su-Ata_ESP      1   GiB
├─p2:Crypt_Su-Ata_Linux         LUKS                        GiB
│ └─Su-Ata_Linux                btrfs   Su-Ata_Linux            \mnt\filesystem
└─p3:Crypt_Su-Ata_Swap          LUKS                    32  GiB
  └─Su-Ata_Swap                 swap    Su-Ata_Swap

│                               GPT                         TiB
└─p3:Crypt_Su-Ata_Data          LUKS
  └─Su-Ata_Data                 swap    Su-Ata_Data

│                               GPT                         TiB
├─p1:
├─p2:
├─p3:
├─p4:
└─p5:Crypt_Su-Ata_Work          LUKS
  └─Su-Ata_Work                 ext4    Su-Ata_Work             \home\work
```

## Btrfs layout

The following is the btrfs subvolume layout.

```
Su-Ata_Linux         <Mountpoint>
├─@nixos-root           \
├─@nixos-store          \nix
├─@nixos-persist        \persist
├─@nixos-log            \var\log
├─@nixos-machines       \var\lib\machines
├─@nixos-portables      \var\lib\portables
└─@home                 \home
```
