# Configuring git
{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "corepresentable";
    userEmail = "joseph.hirsh@gmail.com";
    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      pull = {
        rebase = false;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
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
  # Shell alias for working with our flake
  programs.zsh.shellAliases.git-flake = "git -C \"\${FLAKE}\"";
}
