# NixOS: nixosModules/features/gnome.nix

{ lib, config, inputs, outputs, myLib, pkgs, rootPath, ... }: {
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable gnome login
    displayManager = {
      gdm.enable = true;
      # Enable auto login
      autoLogin = {
        enable = true;
        user = "batuhan";
      };
    };
    # Enable gnome
    desktopManager = {
      gnome.enable = true;
    };
    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
