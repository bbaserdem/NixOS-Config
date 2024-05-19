# Remmina config
{pkgs, ...}: {
  services.remmina = {
    enable = true;
    package = pkgs.remmina;
    systemdService = {
      enable = true;
    };
  };
}
