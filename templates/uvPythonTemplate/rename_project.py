#!/usr/bin/env python3
"""
Script to rename the project from 'template' to a new name.
Updates all relevant files and renames the directory.
"""

import os
import re
import shutil
import sys
from pathlib import Path


def sanitize_name(name: str) -> str:
    """Convert project name to Python package name standard (replace - with _)"""
    return name.replace("-", "_")


def update_file(file_path: Path, replacements: list[tuple[str, str]]) -> None:
    """Update a file with the given replacements."""
    content = file_path.read_text()
    
    for old, new in replacements:
        content = content.replace(old, new)
    
    file_path.write_text(content)
    print(f"Updated: {file_path}")


def rename_project(old_name: str, new_name: str) -> None:
    """Rename the project from old_name to new_name."""
    
    # Sanitize the new name for Python package
    new_name_sanitized = sanitize_name(new_name)
    
    print(f"Renaming project from '{old_name}' to '{new_name}'")
    if new_name != new_name_sanitized:
        print(f"Python package name will be: '{new_name_sanitized}'")
    
    # Define file updates
    updates = [
        # pyproject.toml - 6 occurrences
        {
            "file": "pyproject.toml",
            "replacements": [
                (f'name = "{old_name}"', f'name = "{new_name}"'),
                (f'{old_name} = "{old_name}.main:main"', f'{new_name} = "{new_name_sanitized}.main:main"'),
                (f'--cov={old_name}', f'--cov={new_name_sanitized}'),
                (f'source = ["src/{old_name}"]', f'source = ["src/{new_name_sanitized}"]'),
                (f'packages = ["src/{old_name}"]', f'packages = ["src/{new_name_sanitized}"]'),
            ]
        },
        # python.nix
        {
            "file": "python.nix",
            "replacements": [
                (f'name = "{old_name}";', f'name = "{new_name}";'),
            ]
        },
        # uv.lock
        {
            "file": "uv.lock",
            "replacements": [
                (f'name = "{old_name}"', f'name = "{new_name}"'),
            ]
        },
        # package.json
        {
            "file": "package.json",
            "replacements": [
                (f'"name": "{old_name}"', f'"name": "{new_name}"'),
            ]
        },
    ]
    
    # Apply file updates
    for update in updates:
        file_path = Path(update["file"])
        if file_path.exists():
            update_file(file_path, update["replacements"])
        else:
            print(f"Warning: {file_path} not found")
    
    # Rename the directory
    old_dir = Path(f"src/{old_name}")
    new_dir = Path(f"src/{new_name_sanitized}")
    
    if old_dir.exists():
        shutil.move(str(old_dir), str(new_dir))
        print(f"Renamed directory: {old_dir} -> {new_dir}")
    else:
        print(f"Warning: Directory {old_dir} not found")
    
    print("\nProject rename completed!")
    print("\nNote: You may need to:")
    print("- Run 'uv sync' to update dependencies")
    print("- Update any import statements if they reference the old name")
    print("- Update README.md and other documentation")


def main():
    if len(sys.argv) != 2:
        print("Usage: python rename_project.py <new_project_name>")
        sys.exit(1)
    
    new_name = sys.argv[1]
    old_name = "template"
    
    # Confirm action
    print(f"This will rename the project from '{old_name}' to '{new_name}'")
    response = input("Continue? (y/N): ")
    
    if response.lower() != 'y':
        print("Aborted.")
        sys.exit(0)
    
    rename_project(old_name, new_name)


if __name__ == "__main__":
    main()