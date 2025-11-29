import tomllib
from pathlib import Path

def _get_version() -> str:
    pyproject_path = Path(__file__).parents[2] / "pyproject.toml"
    with open(pyproject_path, "rb") as f:
        pyproject = tomllib.load(f)
    return pyproject["project"]["version"]

__version__ = _get_version()