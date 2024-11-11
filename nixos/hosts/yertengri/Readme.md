# Yertengri

`Yertengri` means *earth god*, and is my PC.
The PC is built, and therefore does not have default hardware configuration

# Disk Layout

The disk layout is shown below;

```
<Partition:label>               <fs>    <Label>         <Size>  <Mountpoint>
                                GPT                         TiB
├─p1:Yertengri_ESP              exfat   Yertengri_ESP   1   GiB
├─p2:Crypt_Yertengri_Linux      LUKS                        GiB
│ └─Yertengri_Linux             btrfs   Yertengri_Linux         \mnt\filesystem
└─p3:Crypt_Yertengri_Swap       LUKS                    32  GiB
  └─Yertengri_Swap              swap    Yertengri_Swap

                                GPT                         TiB
└─p3:Crypt_Yertengri_Data       LUKS
  └─Yertengri_Data              swap    Yertengri_Data

                                GPT                         TiB
├─p1:
├─p2:
├─p3:
├─p4:
└─p5:Crypt_Yertengri_Work       LUKS
  └─Yertengri_Work              ext4    Yertengri_Work          \home\work
```

## Yertengri btrfs layout

The following is the btrfs subvolume layout
```
Yertengri_Linux         <Mountpoint>
├─@nixos-root           \
├─@nixos-store          \nix
├─@nixos-persist        \persist
├─@nixos-log            \var\log
├─@nixos-machines       \var\lib\machines
├─@nixos-portables      \var\lib\portables
└─@home                 \home
```

# Hardware

| Hardware | Model |
| -------- | ----- |
