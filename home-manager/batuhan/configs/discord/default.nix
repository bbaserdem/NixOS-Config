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
    config = {
      frameless = true;
      transparent = true;
      disableMinSize = true;
    };
  };

}
