# ZSH config
{
  config,
  pkgs,
  lib,
  ...
}: let
  libDir = "direnv/lib/use_gitenv.sh";
in {
  # Enable direnv for our shells
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    stdlib = ''
      source "${config.xdg.configHome}/${libDir}"
    '';
  };

  # Create my own module, for setting worktree root and current repo root
  xdg.configFile = {
    ${libDir}.text = ''
      use_gitenv() {
        log_status "Setting git environment variables..."

        # Safely get current branch name
        if git rev-parse --abbrev-ref HEAD &>/dev/null; then
          export GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
        else
          export GIT_BRANCH=""
        fi

        # Get repo root dir
        if git rev-parse --show-toplevel &>/dev/null; then
          export GIT_ROOT="$(git rev-parse --show-toplevel)"
        fi

        # Get the root of the worktree
        if git rev-parse --git-common-dir &>/dev/null; then
          git_common_dir="$(git rev-parse --git-common-dir)"
          if [[ "$git_common_dir" = /* ]]; then
            export GIT_WORKTREE_ROOT="$(realpath "$git_common_dir/..")"
          else
            export GIT_WORKTREE_ROOT="$(realpath "$GIT_ROOT/$git_common_dir/..")"
          fi
        fi
      }
    '';
  };

  # Reformat direnv output to be muted
  home.sessionVariables = {
    "DIRENV_LOG_FORMAT" = "$'\\e[2;1;3mdirenv:\\e[22;23m %s\\e[0m'";
  };
}
