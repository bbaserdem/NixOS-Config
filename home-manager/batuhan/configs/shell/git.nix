# Configuring git
{
  pkgs,
  config,
  ...
}: {
  # Git settings
  programs.git = {
    enable = true;
    userName = "bbaserdem";
    userEmail = "baserdemb@gmail.com";
    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
    };
    extraConfig = {
      core = {
        editor = config.home.sessionVariables.EDITOR;
        hooksPath = ".githooks/"
      };
      pull = { rebase = false; };
      push = { autoSetupRemote = true; };
      init = { defaultBranch = "main"; };
    };
  };

  # Lazygit settings
  programs.lazygit = {
    enable = true;
    package = pkgs.lazygit;
    settings = {
      git = {
        commit.autoWrapWidth = 80;
        mainBranches = ["main" "master"];
        parseEmoji = true;
      };
    };
  };

  # Style lazygit
  stylix.targets.lazygit.enable = true;

  # Shell alias for working with our flake
  programs.zsh.shellAliases.git-flake = "git -C \"\${FLAKE}\"";
}
