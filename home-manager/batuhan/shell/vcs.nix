# Configuring git
{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # Gitleaks and hooks
    pre-commit
    pre-commit-hook-ensure-sops
    gitleaks
  ];

  # Github secret
  sops.secrets = {
    gh-auth = {mode = "0600";};
  };

  # Git config
  programs = {
    # Git settings
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        alias = {
          pu = "push";
          co = "checkout";
          cm = "commit";
        };
        user = {
          name = "bbaserdem";
          email = "baserdemb@gmail.com";
        };
        core = {
          editor = config.home.sessionVariables.EDITOR;
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
        os = {
          edit = "${config.home.sessionVariables.EDITOR} {{filename}}";
        };
      };
    };

    # Jujutsu settings
    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "Batuhan Baserdem";
          email = "baserdemb@gmail.com";
        };
      };
    };

    # jjui settings
    jjui = {
      enable = true;
      settings = {
      };
    };

    # Delta pager for diffs
    delta = {
      enable = true;
      options = {
      };
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };

    # Github cli
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        editor = config.home.sessionVariables.EDITOR;
        git_protocol = "ssh";
      };
      hosts = {
        "github.com" = {
          user = config.programs.git.settings.user.name;
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
