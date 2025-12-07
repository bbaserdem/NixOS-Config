# Syncthing
{pkgs, ...}: {
  stylix.targets.foliate.enable = true;
  programs.foliate = {
    enable = true;
  };
}
