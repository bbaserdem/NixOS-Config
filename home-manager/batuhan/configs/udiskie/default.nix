# Syncthing
{
  pkgs,
  ...
}: {
  services.udiskie = {
    enable = true;
    tray = true;
    notify = true;
    automount = false;
  };
}
