# Syncthing
{config, ...}: {
  stylix.targets.obsidian.enable = true;
  programs.obsidian = {
    enable = true;
    vaults = {
      Notes = {
        enable = true;
        target = "${config.home.homeDirectory}/Media/Notes";
      };
    };
  };
}
