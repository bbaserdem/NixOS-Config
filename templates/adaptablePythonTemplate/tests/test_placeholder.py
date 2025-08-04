"""Placeholder test for the template package."""

import pytest
from template import __version__, __package_name__


def test_version():
    """Test that version is set."""
    assert isinstance(__version__, str)
    assert __version__ == "0.0.0"


def test_package_name():
    """Test that package name is set correctly."""
    assert __package_name__ == "template"


def test_import():
    """Test that package can be imported."""
    import template
    assert template is not None