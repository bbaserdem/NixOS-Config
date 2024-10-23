# tools.nix
# A program list of tools that are needed systemwide
{
  pkgs,
  lib,
  config,
  ...
}: {
  # GnuPG related utils
  services.dbus.packages = [ pkgs.gcr ];
  # Install archiving tools into userspace
  environment.systemPackages = with pkgs; [
    git
    jq
    rsync
    wget
    curl
    bash
    dash
    zsh
    openssh
    gnupg
    wireguard-tools
    neofetch
  ];
}
