"""SkyFi - Template for SkyFi projects."""

__version__ = "0.1.0"
__author__ = "Batuhan Baserdem"
__email__ = "baserdemb@gmail.com"

from skyfi.core import SkyFiCore
from skyfi.utils import get_greeting

__all__ = ["SkyFiCore", "get_greeting", "__version__"]
