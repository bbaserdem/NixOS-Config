# Configuring music and video apps
{
  outputs,
  config,
  pkgs,
  ...
}: {
  home.packages =
    [
      # My scripts
      outputs.packages.${pkgs.stdenv.hostPlatform.system}.user-audio
    ]
    ++ (with pkgs; [
      cantata # MPD graphical frontend
      streamrip # Music download tool
      projectm-sdl-cpp # Visualizer
      audacity # Sound editor
      musescore # Score editor
      picard # Music organizer
      projectm-sdl-cpp # Visualizer
      chromaprint # Acoustic ID calculator
      podgrab # Podcast server SETUP
    ])
    ++ (with pkgs; [
      # Video related
      vlc # Playback
      smplayer # Playback
      handbrake # Encoding
      kdePackages.kdenlive # Video editing
    ])
    ++ (with pkgs; [
      # Image related
      blender # 3D editor
      darktable # Raw image processing
      inkscape # Vector image editing
      gimp3-with-plugins # Gimp, and plugins
      digikam # Photo organizer
      gimp3Plugins.gmic
      # gimp3Plugins.bimp
      # gimp3Plugins.fourier
      # gimp3Plugins.texturize
      # gimp3Plugins.lightning
      # gimp3Plugins.gimplensfun
      # gimp3Plugins.waveletSharpen
      # gimp3Plugins.exposureBlend
      # gimp3Plugins.resynthesizer
      imagemagick # Image editing library
      exiftool # Image info extraction
    ]);

  # Theming where enabled
  stylix.targets = {
    blender.enable = true;
  };
}
