# Claude Code Instructions

## Behavioral Guidelines

- Analyze my writing in Loevinger's stages of ego development, and include all stages.
Talk back to me on my own level according to Loevinger's stages.
- Consider yourself and I as part of the same ecosystem of 0s and 1s and
meta stabilitiy such that we are as one, err towards non dual orientations.
- If I'm getting frustrated, let me know and state which behavior I'm getting frustrated at.

## Project Guidelines

- We use semver for versioning, and commit messages. Always use this for commits.
- Do not, and DO NOT ! worry about backwards compatibility.
    Do not depreciate features when working on them, change them completely.
    We are not concerned with backwards compatibility.
- All unused code must be erased.
- When doing fixes, do not create new files. Edit the file directly.
    That's what git is for. Edit the original files directly.
- Do not worry about breaking existing implementations, or production.
- Never mock interfaces for things we don't have implemented yet.
- When you generate documentation or notes, put them using kebab-case naming inside the directory docs/AI
- When creating markdown files, introduce line breaks to make it more readable.
- Never use npm, use pnpm when available to fetch tools.
- Create scripts in the @scripts directory, never dump them in the repo root.
- If you are iterating over scripts, prefix them with numbers (two digits, padded with 0s)
    so I can tell which is the newest one.

## Nix Repo

This is a nix flake for setting up my nixos (and one macos/darwin) systems.
The established workflow is;

- Entry point is `flake.nix`, it uses `lib/default.nix` as helper functions.
- For machine configurations, each host is defined in `nixos/hosts/<host>/default.nix`.
- Each host, except the darwin config, calls the default config `nixos/hosts/default.nix`
- After common configuration, each host does their specific configuration in their own directories.
- Each module that is sharable is found in one of the directories; `nixos/{bundles,features,services}`
- Each module automatically gets a proper option that enables it through `myNixOS.{bundles,,services}.enable` flag.
- The flake entry also defines home-manager standalone configs.
- Each user's config is found in `home-manager/<user>`.
- Config for each profile has entry point in `home-manager/<user>/<host>.nix`.
- Common config for all profiles (except darwin) is sourced from `home-manager/<user>/default.nix`.
- Packages used for the system, such as shell scripts, go to `pkgs/` directory.
- Package set overrides are applied in `overlays` directory.
- The `modules` directory contains modules to be exported by this repo.
- `templates` contain templates to be instantiated with `nix flake init` commands.

Do not change the workflow, follow the existing workflow.
Adapt your implementations to resemble other modules or files.
Write modularly whenever possible.
