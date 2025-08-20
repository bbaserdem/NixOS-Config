# Configuring image manipulation programs
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Install programs
  home.packages =
    ( # GIMP
      with pkgs.gimp3Plugins; [
        pkgs.gimp3-with-plugins
        gmic
        # bimp
        # fourier
        # texturize
        # lightning
        # gimplensfun
        # waveletSharpen
        # exposureBlend
        # resynthesizer
      ]
    )
    ++ (
      with pkgs; [
        # Image editing
        darktable
        inkscape
        vimiv-qt
        qimgv
        imagemagick
        blender
        digikam
      ]
    );
}
