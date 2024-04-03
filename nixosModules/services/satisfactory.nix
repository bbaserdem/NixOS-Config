{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {

  # -beta experimental \
  systemd.services.satisfactory = {
    preStart = ''
      ${pkgs.steamcmd}/bin/steamcmd \
        +force_install_dir /var/lib/satisfactory/SatisfactoryServer \
        +login anonymous \
        +app_update 1690800 \
        validate \
        +quit
    '';
    script = ''
      ${pkgs.steam-run}/bin/steam-run /var/lib/satisfactory/SatisfactoryServer/FactoryServer.sh -DisablePacketRouting
    '';
    serviceConfig = {
      Nice = "-5";
      Restart = "always";
      User = "satisfactory";
      WorkingDirectory = "/var/lib/satisfactory";
    };
  };
}
