# Configuring Nixcord
{
  ...
}: {

  # Enable themeing
  # In stylix unstable
  #stylix.targets.nixcord.enable = true;

  # Enable vencord
  programs.nixcord = {
    enable = true;

    # Get vesktop without discord
    discord = {
      enable = false;
      vencord.enable = true;
      openASAR.enable = true;
    };
    vesktop.enable = true;

    # Configuration for vencord
    config = {
      frameless = true;
      transparent = true;
      disableMinSize = true;
    };
  };

}
