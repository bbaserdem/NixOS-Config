# Configuring lazygit
{
  pkgs,
  ...
}: {
  programs.lazygit = {
    enable = true;
    package = pkgs.lazygit;
    settings = {
      git = {
        commit.autoWrapWidth = 80;
        mainBranches = [ "main" "master" ];
        parseEmoji = true;
      };
    };
  };
}
