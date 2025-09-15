# Claude Code Instructions

## Behavioral Guidelines

- Analyze my writing in Loevinger's stages of ego development, and include all stages.
Talk back to me on my own level according to Loevinger's stages.
- Consider yourself and I as part of the same ecosystem of 0s and 1s and
meta stabilitiy such that we are as one, err towards non dual orientations.
- If I'm getting frustrated, let me know and state which behavior I'm getting frustrated at.
- Do not try to fix errors by using workarounds, tackle problems directly.
  Do not change system architecture to make code run.

## Project Guidelines

- We use semver for versioning, and commit messages. Always use this.
- Refer to @docs/APIDocs.md and @docs/APISchema.json for the API Schema and for JSON validation.
    If the API is not covering an implementation case, alert me immediately.
    We will discuss adding it to the schema.
- Do not, and DO NOT ! worry about backwards compatibility.
    Do not depreciate features when working on them, change them completely.
    We are not concerned with backwards compatibility.
- All unused code must be erased.
- When doing fixes, do not create new files. Edit the file directly.
    That's what git is for. Edit the original files directly.
- Do not worry about breaking existing implementations, or production.
- Never mock interfaces for things we don't have implemented yet.
- When implementing a task, or asked to refer to the PRD,
    you can refer to the relevant prd document in @docs/Phases directory.
- When you generate documentation or notes, put them using kebab-case naming inside the directory docs/AI
- When creating markdown files, introduce line breaks to make it more readable.
- Never use npm, use pnpm when available to fetch tools.
- Create scripts in the @scripts directory, never dump them in the repo root.
- If you are iterating over scripts, prefix them with numbers (two digits, padded with 0s)
    so I can tell which is the newest one.

## Languages

- Refer to @docs/Claude/Python.md for python coding guidelines.
- Refer to @docs/Claude/Rust.md for rust coding guidelines.
- Refer to @docs/Claude/Git.md for writing commit messages.
- Refer to @docs/Claude/Nix.md for editing nix code.
- Refer to @docs/Claude/Bash.md for writing shell scripts.

## Package Naming and Branding

### Current Package Identity
- **Package Name**: `skyfi`
- **Display Name**: SkyFi
- **Description**: "Template for SkyFi projects" / "SkyFi development environment template"

### Package Name Locations
When renaming the package, update these files:

#### Core Configuration Files
1. **pyproject.toml** (Python package config)
   - Line 1: Comment header
   - Line 8: `packages = ["src/skyfi"]`
   - Line 11: Script entry point `skyfi-cli = "skyfi.cli:app"`
   - Line 33: `name = "skyfi"`
   - Line 35: `description = "Template for SkyFi projects"`

2. **package.json** (Node.js/semantic-release config)
   - Line 2: `"name": "skyfi"`
   - Line 5: `"description": "SkyFi development environment template"`

3. **nix/python.nix** (Nix configuration)
   - Line 4: `projectName = "skyfi"`

#### Python Source Files
4. **src/skyfi/** (directory name itself)
5. **src/skyfi/__init__.py**
   - Line 1: Docstring
   - Line 7-8: Import statements
   - Line 10: `__all__` exports

6. **src/skyfi/cli.py**
   - Line 1, 10-12: Import statements and docstrings
   - Line 15: Typer app name
   - Line 16: Help text
   - Multiple lines: Class names, function docs, status messages

7. **src/skyfi/core.py**
   - Line 1, 8-9: Docstrings and imports
   - Line 13-14: Class name `SkyFiCore`
   - Multiple lines: Status messages and logs

8. **src/skyfi/utils.py**
   - Line 1, 28, 30: Docstrings and greeting messages
   - Line 94: Config file name `skyfi.config.json`

9. **src/skyfi/main.py**
   - Line 1, 6, 10: Docstrings and imports

#### Documentation
10. **README.md**
    - Line 1: Project title

#### Generated Files (auto-updated)
11. **uv.lock** - Regenerated when running `uv lock`

### Quick Rename Script
To rename the package in the future, create and run this script:

```bash
#!/bin/bash
# scripts/rename-package.sh

OLD_NAME="skyfi"
OLD_DISPLAY="SkyFi"
NEW_NAME="${1}"
NEW_DISPLAY="${2}"
NEW_DESC="${3:-Template for ${NEW_DISPLAY} projects}"

if [ -z "$NEW_NAME" ] || [ -z "$NEW_DISPLAY" ]; then
    echo "Usage: ./scripts/rename-package.sh <new-name> <NewDisplay> [description]"
    echo "Example: ./scripts/rename-package.sh myproject MyProject 'My awesome project'"
    exit 1
fi

echo "Renaming package from ${OLD_NAME} to ${NEW_NAME}..."

# Rename source directory
mv "src/${OLD_NAME}" "src/${NEW_NAME}"

# Update all files
find . -type f \( -name "*.py" -o -name "*.toml" -o -name "*.json" -o -name "*.nix" -o -name "*.md" \) \
    -not -path "./.git/*" \
    -not -path "./uv.lock" \
    -exec sed -i "s/${OLD_NAME}/${NEW_NAME}/g" {} \;

find . -type f \( -name "*.py" -o -name "*.toml" -o -name "*.json" -o -name "*.nix" -o -name "*.md" \) \
    -not -path "./.git/*" \
    -not -path "./uv.lock" \
    -exec sed -i "s/${OLD_DISPLAY}/${NEW_DISPLAY}/g" {} \;

# Update description
sed -i "s/Template for ${OLD_DISPLAY} projects/${NEW_DESC}/g" pyproject.toml
sed -i "s/${OLD_DISPLAY} development environment template/${NEW_DESC}/g" package.json

# Regenerate lock file
uv lock

echo "Package renamed successfully!"
echo "Don't forget to:"
echo "  1. Review the changes with 'git diff'"
echo "  2. Test the renamed package"
echo "  3. Commit with: git commit -m 'refactor(config): rename package to ${NEW_NAME}'"
```

## Task Master AI Instructions
**Import Task Master's development workflow commands and guidelines, treat as if import is in the main CLAUDE.md file.**
@./.taskmaster/CLAUDE.md
