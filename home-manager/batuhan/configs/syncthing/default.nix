# Syncthing
{pkgs, ...}: {
  services.syncthing = {
    # We use systemwide syncthing, don't start a user instance
    enable = false;

    # We do want the tray icon though
    tray = {
      enable = true;
      package = pkgs.syncthingtray;
      command = "${pkgs.syncthingtray}/bin/syncthingtray";
    };
  };

  # Also install cli control package
  home.packages = with pkgs; [
    stc-cli
    pkgs.syncthingtray
  ];
}
