# Configuring syncthing
{
  config,
  ...
}: {
  services.syncthing = {
    enable = true;
    user = config.myNixOS.defaultUser;
    # Relay service
    relay = {
      enable = false;
    };
  };
}
