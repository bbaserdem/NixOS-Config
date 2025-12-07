# Syncthing
{pkgs, ...}: {
  stylix.targets.obsidian.enable = true;
  programs.obsidian = {
    enable = true;
    vaults = {
      Notes = {
        enable = true;
        target = "Media/Notes";
      };
    };
  };
}
