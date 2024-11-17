# Neovim Configuration 3.0

My (3rd) neovim configuration for IDE & general typing experience.

# WIP

* Set up keybinds
* Get Mason to work instead of built-in servers.
* Switch from lualine to [heirline](https://github.com/rebelot/heirline.nvim).

# Workflow

* Lazy plugin manager is used.
* LSP and external programs are declared to be extra packages.
  Mason configuration is done, but is disabled for now. (On Nix)


# Languages

The languages I will be setting up to work with are;

[*] Lua
[ ] Markdown
[ ] LaTeX
[ ] C
[ ] Python
[ ] Bash
[ ] POSIX shell (dash)
[ ] Nix

# Keybinds

## Leader Key

The leader key is `<Space>` and leads to plugin functionality.
Also provides the following shortcuts;

| Keybind   | Function                    |
| --------- | --------------------------- |
| Shift C   | Yank to system clipboard    |
| Shift X   | Cut to system clipboard     |
| Shift V   | Paste from system clipboard |

# Plugins

Each plugin is defined in [the plugin loader directory](lua/lazy-plugins).
