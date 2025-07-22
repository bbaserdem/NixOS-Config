# Configuring git
{
  outputs,
  pkgs,
  config,
  ...
}: {
  # My git scripts
  home.packages = [
    outputs.packages.${pkgs.system}.user-git
  ];

  programs = {
    # Git settings
    git = {
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
          hooksPath = ".githooks/";
        };
        pull = {rebase = false;};
        push = {autoSetupRemote = true;};
        init = {defaultBranch = "main";};
      };
    };

    # Lazygit settings
    lazygit = {
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

    # Github cli
    gh = {
      enable = true;
      settings = {
        editor = config.home.sessionVariables.EDITOR;
        git_protocol = "ssh";
      };
      hosts = {
        "github.com" = {
          userName = config.programs.git.userName;
        };
      };
      extensions = with pkgs; [
        gh-s
        gh-i
        gh-f
        gh-poi
        gh-eco
        gh-notify
        gh-skyline
        gh-contribs
        gh-screensaver
        gh-markdown-preview
      ];
    };
    gh-dash = {
      enable = true;
    };
  };

  # Style lazygit
  stylix.targets.lazygit.enable = true;

  # Shell alias for working with our flake
  programs.zsh.shellAliases.git-flake = "git -C \"\${FLAKE}\"";
}
