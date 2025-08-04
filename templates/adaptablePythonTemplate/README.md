# Python UV+Nix Template

A sophisticated Python project template that seamlessly integrates [UV](https://docs.astral.sh/uv/) package management with [Nix](https://nixos.org/) for reproducible development environments and builds.

## ✨ Features

### 🚀 **Modern Python Development**
- **UV Package Management**: Fast dependency resolution and virtual environment management
- **Python 3.13**: Latest Python version with modern features
- **Modular Dependencies**: Organized optional dependency groups (testing, docs, dev)
- **Type Safety**: MyPy integration with strict typing configuration
- **Code Quality**: Ruff linting and Black formatting with comprehensive rules

### 🔧 **Nix Integration (UV2NIX)**
- **Reproducible Builds**: Deterministic environments across all systems
- **Custom UV2NIX System**: Advanced integration between UV and Nix ecosystems
- **Modular Shell Environments**: Specialized environments for different workflows
- **Flexible Project Spec**: Support for both single packages and monorepo layouts
- **Editable Development**: Proper editable installs in Nix environments

### 🧪 **Testing & Quality**
- **Pytest Integration**: Comprehensive test framework with coverage reporting
- **Multiple Test Environments**: Isolated testing environments with specific dependencies
- **Coverage Reporting**: HTML and terminal coverage reports
- **Automated Checks**: Integrated with Nix flake checks for CI/CD

### 📚 **Documentation**
- **Sphinx Ready**: Documentation generation with modern themes
- **API Documentation**: Automatic API docs with pdoc
- **Markdown Support**: MyST parser for Markdown in documentation
- **Diagram Support**: GraphViz and PlantUML integration

### 🔄 **Development Workflows**
- **Multiple Shell Environments**: Minimal, testing, docs, and full environments
- **Automated Scripts**: Project initialization, cleaning, and status checking
- **Development Server Support**: Built-in development server configuration
- **Lint and Format**: One-command code quality enforcement

## 📋 Quick Start

### Prerequisites
- [Nix](https://nixos.org/download.html) with flakes enabled
- [Direnv](https://direnv.net/) (recommended for automatic environment loading)

### Getting Started

1. **Clone and Initialize**
   ```bash
   git clone <repository-url> my-python-project
   cd my-python-project
   nix run .#init  # Initialize project environment
   ```

2. **Enter Development Environment**
   ```bash
   nix develop  # Enter default development shell
   # or with direnv: direnv allow
   ```

3. **Install Dependencies**
   ```bash
   uv lock  # Lock dependencies (if not already done)
   ```

4. **Run Tests**
   ```bash
   nix run .#test-all  # Comprehensive testing
   # or: pytest --cov
   ```

5. **Build Documentation**
   ```bash
   nix develop .#docs  # Enter docs environment
   sphinx-build docs/ docs/_build/
   ```

## 🏗️ Project Structure

```
├── src/template/           # Python source code
│   ├── __init__.py        # Package initialization
│   └── main.py            # Main entry point
├── tests/                 # Test files
│   ├── __init__.py
│   └── test_template.py
├── nix/                   # Nix configuration
│   ├── python.nix         # Python project specification
│   ├── uv2nix/            # UV+Nix integration system
│   ├── shells/            # Development shell configurations
│   ├── packages/          # Package definitions
│   ├── apps/              # Runnable applications
│   └── variants/          # Project templates
├── pyproject.toml         # Python project configuration
├── uv.lock               # Dependency lock file
├── flake.nix             # Nix flake configuration
├── flake.lock            # Nix dependency lock file
└── AGENT.md              # AI agent usage guidelines
```

## 🛠️ Development Environments

The template provides specialized development environments for different workflows:

### Available Environments

| Environment | Command | Purpose | Tools Included |
|-------------|---------|---------|----------------|
| **Default** | `nix develop` | General development | Base tools + Python + project dependencies |
| **Minimal** | `nix develop .#minimal` | Lightweight tasks | Base tools only (git, uv, ripgrep, etc.) |
| **Testing** | `nix develop .#testing` | Running tests | Python + testing dependencies (pytest, coverage, black) |
| **Documentation** | `nix develop .#docs` | Building docs | Python + documentation dependencies (sphinx, pdoc) |
| **Full** | `nix develop .#full` | Complete workflow | All tools and dependencies |

### Environment Features

- **UV Integration**: Automatic virtual environment management
- **Python 3.13**: Latest Python with modern features
- **System Tools**: Essential development utilities (git, ripgrep, fd, bat, etc.)
- **Isolated Dependencies**: Each environment has only relevant dependencies
- **Fast Activation**: Nix caching ensures quick environment startup

## 📦 Dependency Management

### Adding Dependencies

```bash
# Runtime dependencies
uv add requests numpy pandas

# Development dependencies
uv add --dev pytest-mock mypy-extensions

# Optional dependency groups
uv add --optional-dependencies testing pytest-xdist pytest-benchmark
uv add --optional-dependencies docs sphinx-autodoc-typehints

# Lock dependencies
uv lock

# Reload environment (if using direnv)
direnv reload
```

### Dependency Groups

The template uses organized dependency groups in `pyproject.toml`:

- **`dev`**: General development tools (mypy, ruff, pytest, pytest-cov)
- **`testing`**: Testing-specific packages (pytest, coverage, black, isort)
- **`docs`**: Documentation packages (sphinx, sphinx-rtd-theme, myst-parser, pdoc)

## 🧪 Testing

### Running Tests

```bash
# Comprehensive testing (recommended)
nix run .#test-all

# All tests with coverage
nix develop --command pytest --cov

# Specific test file
nix develop --command pytest tests/test_template.py

# Specific test function
nix develop --command pytest tests/test_template.py::test_package_name

# Tests with different options
nix develop --command pytest -v              # Verbose output
nix develop --command pytest -x              # Stop at first failure
nix develop --command pytest -k "test_main"  # Run tests matching pattern
```

### Testing in Specialized Environment

```bash
# Enter testing environment
nix develop .#testing

# Now run tests with specialized testing tools
pytest --cov --cov-report=html
black --check src/
isort --check-only src/
```

### Coverage Reports

```bash
# Terminal coverage report
pytest --cov --cov-report=term-missing

# HTML coverage report
pytest --cov --cov-report=html
open htmlcov/index.html  # View in browser
```

## 📚 Documentation

### Building Documentation

```bash
# Enter documentation environment
nix develop .#docs

# Build Sphinx documentation
sphinx-build docs/ docs/_build/

# Generate API documentation
pdoc src/template/

# Convert Markdown with Pandoc
pandoc README.md -o README.html
```

### Documentation Tools Available

- **Sphinx**: Main documentation generator with RTD theme
- **MyST Parser**: Markdown support in Sphinx
- **pdoc**: Automatic API documentation generation
- **Pandoc**: Universal document converter
- **GraphViz & PlantUML**: Diagram generation

## 🔄 Available Commands

### Project Management
```bash
nix run .#init         # Initialize project environment
nix run .#clean        # Clean project artifacts
nix run .#status       # Show development environment status
```

### Development Workflow
```bash
nix run .#test-all     # Run all tests with coverage
nix run .#lint-all     # Run all linters (ruff, mypy)
nix run .#format-all   # Format all code (black, isort)
```

### Web Development
```bash
nix run .#dev-server   # Start development server
```

### Building and Checking
```bash
nix build              # Build the main package
nix flake check        # Run all Nix checks and tests
```

## ⚙️ Configuration

### Python Project Specification

The template uses a flexible project specification in `nix/python.nix`:

```nix
{
  # Project metadata
  projectName = "template";           # Project name from pyproject.toml
  projectRoot = ./..;                 # Location of pyproject.toml
  projectDir = ./src/template;        # Source code directory
  
  # Monorepo support (future)
  emptyRoot = false;                  # Root contains Python package
  workspaces = [];                    # Additional workspace specifications
}
```

### Customizing for Your Project

1. **Update Project Name**
   ```nix
   # nix/python.nix
   projectName = "your-project-name";
   ```

2. **Update pyproject.toml**
   ```toml
   [project]
   name = "your-project-name"
   description = "Your project description"
   authors = [
       { name = "Your Name", email = "your.name@example.com" }
   ]
   ```

3. **Rename Source Directory**
   ```bash
   mv src/template src/your-project-name
   ```

4. **Update Dependencies**
   ```bash
   uv add your-dependencies
   uv lock
   ```

## 🏛️ Architecture

### UV2NIX Integration

The template features a sophisticated UV+Nix integration system:

- **Workspace Discovery**: Automatic detection of Python packages and workspaces
- **Dependency Resolution**: UV handles Python dependencies, Nix handles system dependencies
- **Virtual Environment Management**: Seamless integration of UV venvs with Nix shells
- **Build System Overrides**: Custom handling for problematic Python packages
- **Editable Development**: Proper editable installs in Nix environments

### Modular Shell System

Development environments are built using a modular composition system:

- **Base Configuration**: Common tools and settings shared across all environments
- **Specialized Shells**: Environment-specific tools and dependencies
- **Clean Inheritance**: Each environment builds upon others without duplication
- **Easy Extension**: Simple to add new specialized environments

### Nix Architecture

```
nix/
├── python.nix         # Project specification
├── uv2nix/           # UV+Nix integration modules
│   ├── workspace.nix     # Workspace discovery
│   ├── overlays.nix      # Package overlays
│   ├── python-sets.nix   # Python environment construction
│   └── virtualenv.nix    # Virtual environment creation
├── shells/           # Development environment definitions
├── packages/         # Package definitions
├── apps/            # Runnable applications
└── checks.nix       # Test configurations
```

## 🔮 Future Features

### Monorepo Support

The template is designed to support monorepo layouts:

```nix
# Future monorepo configuration
{
  emptyRoot = true;  # Root contains no Python package
  workspaces = [
    { projectName = "core"; projectRoot = ./packages/core; }
    { projectName = "cli"; projectRoot = ./packages/cli; }
    { projectName = "web"; projectRoot = ./packages/web; }
  ];
}
```

**Important**: When setting `emptyRoot = true`, you must remove all `[build-system]` and `[tool.*]` definitions from the root `pyproject.toml`. The root should only contain workspace configuration:

```toml
# Root pyproject.toml for empty root workspaces
[tool.uv.workspace]
members = ["packages/*"]
```

### Additional Integrations

- **Container Support**: Docker/Podman integration with Nix
- **CI/CD Templates**: GitHub Actions and GitLab CI configurations
- **Pre-commit Hooks**: Automated code quality checks
- **VSCode Integration**: Development container and settings

## 🤝 Contributing

### Development Setup

1. **Fork and clone the repository**
2. **Enter development environment**: `nix develop`
3. **Make changes and test**: `nix run .#test-all`
4. **Check code quality**: `nix run .#lint-all`
5. **Format code**: `nix run .#format-all`
6. **Submit pull request**

### Testing Changes

```bash
# Test all functionality
nix flake check

# Test specific environments
nix develop .#testing --command pytest
nix develop .#docs --command sphinx-build --help

# Test building packages
nix build .#template
```

## 📖 Additional Resources

- **[AGENT.md](./AGENT.md)**: Detailed guidelines for AI agents working with this template
- **[nix/README.md](./nix/README.md)**: Comprehensive Nix architecture documentation
- **[UV Documentation](https://docs.astral.sh/uv/)**: Official UV package manager documentation
- **[Nix Manual](https://nixos.org/manual/nix/stable/)**: Official Nix documentation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using UV + Nix for the modern Python developer**
