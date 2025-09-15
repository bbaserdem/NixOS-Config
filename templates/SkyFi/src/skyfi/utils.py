"""Utility functions for SkyFi."""

from datetime import datetime
from pathlib import Path
from typing import Any


def get_greeting(name: str, formal: bool = False) -> str:
    """Generate a greeting message.

    Args:
        name: Name to greet
        formal: Whether to use formal greeting

    Returns:
        Formatted greeting string
    """
    current_hour = datetime.now().hour

    if current_hour < 12:
        time_greeting = "Good morning"
    elif current_hour < 18:
        time_greeting = "Good afternoon"
    else:
        time_greeting = "Good evening"

    if formal:
        return f"{time_greeting}, esteemed {name}. Welcome to SkyFi."
    else:
        return f"{time_greeting}, {name}! Ready to fly with SkyFi?"


def format_output(data: Any) -> str:
    """Format output data for display.

    Args:
        data: Data to format

    Returns:
        Formatted string representation
    """
    if isinstance(data, dict):
        lines = []
        for key, value in data.items():
            lines.append(f"{key}: {value}")
        return "\n".join(lines)
    elif isinstance(data, list):
        return "\n".join(str(item) for item in data)
    else:
        return str(data)


def ensure_directory(path: Path) -> Path:
    """Ensure a directory exists, creating it if necessary.

    Args:
        path: Directory path

    Returns:
        The path object
    """
    path.mkdir(parents=True, exist_ok=True)
    return path


def get_project_root() -> Path:
    """Get the project root directory.

    Returns:
        Path to project root
    """
    current = Path.cwd()

    # Look for pyproject.toml to identify project root
    while current != current.parent:
        if (current / "pyproject.toml").exists():
            return current
        current = current.parent

    # Fallback to current directory
    return Path.cwd()


def parse_config(config_path: Path | None = None) -> dict[str, Any]:
    """Parse configuration from a file.

    Args:
        config_path: Path to config file (defaults to project root)

    Returns:
        Configuration dictionary
    """
    if config_path is None:
        config_path = get_project_root() / "skyfi.config.json"

    if not config_path.exists():
        return {
            "version": "0.1.0",
            "debug": False,
            "verbose": False,
            "features": {
                "processing": True,
                "analytics": False,
            },
        }

    import json

    return json.loads(config_path.read_text())
