# Configuring MPV
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
  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
    config = {
      keepaspect = true;
      autofit-larger = "90%x90%";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      keep-open = true;
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";
    };
  };
}
