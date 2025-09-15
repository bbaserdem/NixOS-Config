# Commit Conventions

This project uses [Conventional Commits](https://www.conventionalcommits.org/) with semantic-release for automated versioning across Go, Python, and Rust components.

## ⚠️ IMPORTANT: Scope is REQUIRED

This project enforces **mandatory scopes** in all commit messages. The scope MUST be one from the predefined list below.

## Commit Message Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Required Format Rules
- **Type**: Must be one of the valid types listed below
- **Scope**: REQUIRED - must be from the allowed scopes list
- **Subject**: Start with lowercase, no period at the end, imperative mood
- **Body**: Optional, wrap at 72 characters
- **Footer**: Optional, for breaking changes or issue references

## Valid Types

| Type | Description | Version Impact | When to Use |
|------|------------|----------------|-------------|
| **feat** | New feature | MINOR (0.X.0) | Adding new functionality |
| **fix** | Bug fix | PATCH (0.0.X) | Fixing broken functionality |
| **docs** | Documentation only | None | README, comments, docs |
| **style** | Code formatting | None | Whitespace, semicolons, etc |
| **refactor** | Code restructuring | None | Neither adds feature nor fixes bug |
| **perf** | Performance improvement | PATCH (0.0.X) | Speed/memory optimizations |
| **test** | Testing changes | None | Adding/updating tests |
| **build** | Build system changes | None | Build scripts, dependencies |
| **ci** | CI/CD changes | None | GitHub Actions, pipelines |
| **chore** | Maintenance tasks | None | Routine tasks, cleanup |
| **revert** | Revert previous commit | Varies | Undoing a previous commit |

## Required Scopes

The scope is **MANDATORY** for all commits. Choose from:

### Language Scopes
- **go** - Go language specific changes
- **python** - Python language specific changes  
- **rust** - Rust language specific changes

### Component Scopes
- **api** - API endpoints, REST/GraphQL changes
- **parser** - Code parsing engine changes
- **watcher** - File system watcher changes
- **daemon** - Background service/daemon changes
- **neo4j** - Graph database related changes
- **cli** - Command-line interface changes

### Infrastructure Scopes
- **ci** - Continuous integration configuration
- **deps** - Dependency updates
- **config** - Configuration file changes
- **build** - Build system configuration
- **test** - Test infrastructure changes
- **docs** - Documentation changes

## Valid Commit Message Examples

### ✅ CORRECT Examples
```bash
# Feature addition
feat(python): add async support for file processing

# Bug fix
fix(api): handle null values in response

# Documentation
docs(config): update README with new setup instructions

# CI/CD changes
ci(build): add semantic release workflow

# Dependencies
build(deps): update GDAL to version 3.11.0

# Multiple components
refactor(python): restructure module imports

# Performance
perf(parser): optimize AST traversal
```

### ❌ INCORRECT Examples
```bash
# Missing scope (WILL BE REJECTED)
feat: add new feature

# Invalid scope
feat(backend): add API endpoint  # 'backend' is not in allowed list

# Wrong type for the change
feat(ci): add GitHub Actions  # Should be 'ci(ci):' or 'ci(build):'

# No scope
fix: correct typo
```

## Validation and Hooks

This project uses TWO layers of validation:

1. **Local Git Hook** (`.githooks/commit-msg`)
   - Validates basic format with regex
   - Runs immediately on commit
   - Can be bypassed with `--no-verify` (not recommended)

2. **Commitlint** (`commitlint.config.js`)
   - Validates against exact scope list
   - Enforces scope requirement
   - Runs in CI/CD pipeline
   - Cannot be bypassed

## Breaking Changes

Add `BREAKING CHANGE:` in the footer or `!` after the type/scope:

```
feat(api)!: change API response format

BREAKING CHANGE: API responses now use camelCase instead of snake_case
```

This triggers a MAJOR version bump.

## Examples

### Feature
```
feat(python): add incremental parsing support

Implement tree-sitter based incremental parsing for Python files
to improve performance on large codebases.
```

### Bug Fix
```
fix(watcher): handle file permission errors gracefully

Previously the watcher would crash when encountering files without
read permissions. Now it logs a warning and continues.
```

### Multi-language Change
```
feat: add support for async operations

- Go: Added goroutine-based async processing
- Python: Implemented asyncio support
- Rust: Added tokio async runtime
```

### Performance
```
perf(parser): optimize AST traversal for large files

Reduced memory usage by 40% when parsing files over 10MB
```

## Version Bumping Rules

- **PATCH** (0.0.X): `fix`, `perf`, `revert` (backwards compatible bug fixes)
- **MINOR** (0.X.0): `feat` (backwards compatible new features)
- **MAJOR** (X.0.0): Breaking changes (any commit with `BREAKING CHANGE:` or `!`)

## Automation

When you push to the `main` branch with properly formatted commits:

1. semantic-release analyzes commit messages
2. Determines the version bump type
3. Updates version in:
   - `pyproject.toml` (Python)
   - `Cargo.toml` (Rust)
   - `go.mod` (Go modules use git tags)
   - `package.json` (Node.js/npm)
4. Generates CHANGELOG.md
5. Creates a GitHub release
6. Tags the commit with the new version

## Troubleshooting Common Issues

### "Scope-empty" Error
```
✖ scope may not be empty [scope-empty]
```
**Solution**: Always include a scope from the allowed list.

### "Scope-enum" Error  
```
✖ scope must be one of [go, python, rust, api, ...] [scope-enum]
```
**Solution**: Use only scopes from the predefined list above.

### Hook vs Commitlint Mismatch
If the git hook passes but commitlint fails, it's because:
- The hook uses regex (more permissive)
- Commitlint checks exact scope values (strict)

## Quick Reference Card

```
Format: <type>(<scope>): <subject>

Types:     feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert
Scopes:    go|python|rust|api|parser|watcher|daemon|neo4j|cli|ci|deps|config|build|test|docs
           ↑ REQUIRED - must use one from this list

Examples:
  ci(build): add GitHub Actions workflow
  feat(python): implement GDAL integration  
  fix(cli): correct typer command parsing
  docs(config): update package naming guide
  build(deps): add semantic-release packages
```

## Local Testing

Test your commit message:
```bash
echo "feat(python): add new parser" | npx commitlint
```

Dry run semantic-release:
```bash
npx semantic-release --dry-run
```

## Bypass Options (Use Sparingly)

### Bypass local git hook (NOT recommended):
```bash
git commit --no-verify -m "your message"
```

### Bypass for emergency hotfixes:
```bash
SKIP_HOOKS=1 git commit -m "hotfix(api): emergency patch"
```