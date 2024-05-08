# Yel Ana

`Yel Ana` means *mother wind*, and is my Laptop.
My laptop is a **Framework Laptop 13 DIY Edition (AMD Ryzen™ 7040 Series)**.

# Disk Layout

The OS and data live within a 4TB SSD from Crucial; model number `CT4000P3PSSD8`.
The disk layout is shown below;

```
<Partition:label>               <fs>    <Label>         <Size>  <Mountpoint>
nvme0n1                         GPT                     3.6 TiB
├─p1:Yel-Ana_ESP                exfat   Yel-Ana_ESP     1   GiB
├─p2:Crypt_Yel-Ana_NixOS        LUKS                    300 GiB
│ └─Yel-Ana_NixOS               btrfs   Yel-Ana_NixOS           \mnt\filesystem
├─p3:Crypt_Yel-Ana_NixOS_Swap   LUKS                    50  GiB
│ └─Yel-Ana_NixOS_Swap          swap    Yel-Ana_NixOS_S
└─p4:Crypt_Yel-Ana_Data         LUKS                    3.3 TiB
  └─Yel-Ana_Data                ext4    Yel-Ana_Data            \home\data
```

## Yel Ana btrfs layout

The following is the btrfs subvolume layout
```
Yel-Ana_NixOS           <Mountpoint>
├─@nixos-root           \
├─@nixos-store          \nix
├─@nixos-persist        \persist
├─@nixos-log            \var\log
├─@nixos-machines       \var\lib\machines
├─@nixos-portables      \var\lib\portables
└─@home                 \home
```
