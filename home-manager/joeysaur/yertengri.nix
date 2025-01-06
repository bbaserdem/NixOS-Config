# joeysaur@yertengri home configuration
{config, ...}: {
  # Just default to regular now
  imports = [
    ./default.nix
  ];
  # Create data symlinks
  home.file."Media".source = config.lib.file.mkOutOfStoreSymlink "/home/work/Joey-Media";
  home.file."Work".source = config.lib.file.mkOutOfStoreSymlink "/home/work/Joey-Work";
}
