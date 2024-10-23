# Configuring virt-manager to auto-start
{
  pkgs,
  config,
  ...
}: {
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
