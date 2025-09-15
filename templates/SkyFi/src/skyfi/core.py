"""Core functionality for SkyFi."""

from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Any

from skyfi import __version__
from skyfi.utils import parse_config


@dataclass
class SkyFiCore:
    """Core SkyFi processing engine."""

    verbose: bool = False
    config: dict[str, Any] = field(default_factory=dict)
    _initialized: bool = False

    def __post_init__(self) -> None:
        """Initialize the core after dataclass initialization."""
        if not self.config:
            self.config = parse_config()
        self._initialized = True

        if self.verbose:
            print(f"SkyFi Core initialized (v{__version__})")

    def process_file(self, file_path: Path) -> dict[str, Any]:
        """Process a file and return results.

        Args:
            file_path: Path to file to process

        Returns:
            Dictionary with processing results
        """
        if not self._initialized:
            raise RuntimeError("SkyFi Core not properly initialized")

        if not file_path.exists():
            raise FileNotFoundError(f"File not found: {file_path}")

        # Simulate processing
        file_stats = file_path.stat()
        content = file_path.read_text()

        results = {
            "file": str(file_path),
            "size_bytes": file_stats.st_size,
            "lines": len(content.splitlines()),
            "words": len(content.split()),
            "characters": len(content),
            "processed_at": datetime.now().isoformat(),
            "processor_version": __version__,
        }

        if self.verbose:
            print(f"Processed {file_path.name}: {results['lines']} lines, {results['words']} words")

        return results

    def get_status(self) -> dict[str, Any]:
        """Get current status information.

        Returns:
            Status dictionary
        """
        return {
            "version": __version__,
            "initialized": self._initialized,
            "verbose": self.verbose,
            "config_loaded": bool(self.config),
            "features": self.config.get("features", {}),
            "timestamp": datetime.now().isoformat(),
        }

    def validate(self) -> bool:
        """Validate the core configuration.

        Returns:
            True if valid, False otherwise
        """
        if not self._initialized:
            return False

        required_features = ["processing"]
        features = self.config.get("features", {})

        for feature in required_features:
            if not features.get(feature, False):
                if self.verbose:
                    print(f"Missing required feature: {feature}")
                return False

        return True

    def reset(self) -> None:
        """Reset the core to initial state."""
        self.config = parse_config()
        self._initialized = True

        if self.verbose:
            print("SkyFi Core reset to defaults")
