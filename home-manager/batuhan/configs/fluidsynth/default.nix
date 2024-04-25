# MIDI synthesizer
{
  config,
  pkgs,
  ...
}: {
  services.fluidsynth = {
    enable = true;
    soundService = "pipewire-pulse";
  };
}
