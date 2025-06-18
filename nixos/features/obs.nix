# Module that configures obs
{pkgs, ...}: {
  # Import the matlab package
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      waveform
      droidcam-obs
      obs-backgroundremoval
      abs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
