# Do sound outputs
{
  pkgs,
  lib,
  config,
  ...
}: {
  # Using PipeWire as the sound server conflicts with PulseAudio.
  # This option requires `hardware.pulseaudio.enable` to be set to false.
  services.pulseaudio.enable = false;
  # Recommended to have rtkit enabled
  security.rtkit.enable = true;
  # Main enabling script
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;

    # Most this config ripped from package search, and the wiki. I don't get it
    wireplumber = {
      enable = true;
      extraConfig = {
        "log-level-debug" = {
          "context.properties" = {
            # Output Debug log messages as opposed to only the default level (Notice)
            "log.level" = "D";
          };
        };
      };
    };
  };
}
