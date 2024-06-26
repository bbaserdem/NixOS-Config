# batuhan@umay home configuration
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  myLib,
  rootPath,
  ...
}: {
  # Just default to regular now
  imports = [
    ./default.nix
  ];
  # Disable otherwise enabled services on this host
  services.gammastep.enable = lib.mkOverride 500 false;
  services.autorandr.enable = lib.mkOverride 500 false;
}
