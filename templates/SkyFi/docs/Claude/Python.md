# Python Programming Guidelines

- Never try to install packages through pip, we use uv.
- Never try to run uv sync
- Always use this workflow to install python packages;
  (edit pyproject.toml) -> (run uv lock) -> (direnv reload)
- If in a session you add new python dependencies, you much use a refreshed devshell
to run every subsequent code.
- We are using nixos, so never attempt to run any script with uv's venv.
    We will always use venv created by nix.
