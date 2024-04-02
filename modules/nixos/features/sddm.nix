# Module that enables logging in with SDDM

{ pkgs, lib, ... }: {
  services.xserver = {
    enable = true;
    libinput.enable = lib.mkDefault true;
    displayManager = {
      sddm.enable = lib.mkDefault true;
      sddm.theme = "catppuccin";
    };
  };

  environment.systemPackages = with pkgs; 
    catppuccin-sddm-corners
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];
}
