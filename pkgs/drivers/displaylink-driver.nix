# Displaylink driver
{pkgs}: let
  driver = builtins.path {
    path = ./displaylink-610.zip;
    name = "displaylink-610.zip";
  };
in
  pkgs.runCommand "displaylink-610" {} ''
    mkdir -p $out
    cp ${driver} $out/
  ''
