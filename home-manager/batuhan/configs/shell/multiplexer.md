# Multiplexer workflow

I want to have a multiplexer automation workflow.

## Variables

- `GIT_ROOT_DIR`: The directory of the trunk of the repo (root of worktrees)
- `GIT_BRANCH_DIR`: The directory of the specific worktree branch
- `GIT_REPO_NAME`: The name of the main repo
- `GIT_BRANCH_NAME`: The branch name
- `GIT_SESSION_TITLE`: Multiplexer session name
- `GIT_TAB_NAME`: The tab name in the multiplexer

## Workflow

### Entering repo

Create a terminal multiplexer (if session doesn't exist) that will;
- All tabs will have a tab bar and status bar
- Have session name `GIT_SESSION_TITLE`
- Have lazygit at `GIT_ROOT_DIR` in the first tab, named `GIT_REPO_NAME - LazyGit`
- Have on each tab, for each worktree branch a tab named `GIT_REPO_NAME:GIT_BRANCH_NAME`
- Each of these tabs should have two panes by default, and open in `GIT_BRANCH_DIR`

### Creating a new worktree branch

Given a `GIT_BRANCH_NAME`;
- Plan to create a worktree at `GIT_ROOT_DIR/worktrees/sanitized(GIT_BRANCH_NAME)`
- If there are any local branches of the same name
  - Create from local
- If there are any remote branches of the same name
  - Create from remote.
- If the `GIT_BRANCH_NAME` is of the form `<name>{:,-,/}<feat>`.
  - If local or remote branch `<name>` exists
    - Create a new worktree branch based on the `<name>` branch
- Create new worktree branch based on the `<main>/<master>` branch

After creation, if session `GIT_SESSION_TITLE` exists;
- Add a new tab named `GIT_REPO_NAME:GIT_BRANCH_NAME`, with two panes in `GIT_BRANCH_DIR`

# Choices;

Either
- Create zellij layout from a template on repo entry, and alias to launch.
- Use tmux with zellij bindings.
