"""Template package for blog project."""

import tomllib
from importlib.metadata import PackageNotFoundError, metadata, version
from pathlib import Path

# Public API exports
__all__ = ["main", "__version__", "__package_name__"]

# Try to get package name from pyproject.toml first
try:
    pyproject_path = Path(__file__).parent.parent.parent / "pyproject.toml"
    if pyproject_path.exists():
        with open(pyproject_path, "rb") as f:
            pyproject = tomllib.load(f)
            __package_name__ = pyproject["project"]["name"]
    else:
        __package_name__ = __name__.split(".")[-1]
except Exception:
    __package_name__ = __name__.split(".")[-1]

# Fetch metadata from installed package
try:
    __version__ = version(__package_name__)
    _metadata = metadata(__package_name__)
    __author__ = _metadata.get("Author", "Unknown")
    __email__ = _metadata.get("Author-email", "")
except PackageNotFoundError:
    # Fallback for development/editable installs
    __version__ = "0.0.0"
    __author__ = "Unknown"
    __email__ = ""


def main() -> None:
    """Entry point for the template command."""
    print(f"Hello from {__package_name__} v{__version__}!")

