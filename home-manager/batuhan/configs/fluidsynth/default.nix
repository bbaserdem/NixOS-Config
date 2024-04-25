# MIDI synthesizer
{
  inputs,
  config,
  pkgs,
  ...
}: {
  services.fluidsynth = {
    enable = true;
    soundService = "pipewire-pulse";
  };
}
