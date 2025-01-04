-------------------------------------------------
-- name : Tree-Sitter
-- url  : https://github.com/nvim-treesitter/nvim-treesitter
-------------------------------------------------
-- Highlighting based on syntax

local M = {
    "nvim-treesitter/nvim-treesitter",
    build = function ()
        require("nvim-treesitter.install").update(
            { with_sync = true, }
        )()
    end,
    lazy = false,
    -- Auto start this plugin
    priority = 500,
    config = true,
    main = "nvim-treesitter.configs",
    opts = {
        -- Parsers to install by default
        ensure_installed = {
            "bash", "make", "ini", "json", "toml",
            "c", "cpp", "python",
            "lua", "luadoc", "luap", "vim", "vimdoc", "markdown", "latex",
            "nix",
            "git_config", "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "regex"
        },
        auto_install = true,
        highlight = {
            enable = true,
            -- Treesitter with latex causes vimtex to malfunction
            -- however, I still want to use latex ts highlighter in markdown
            -- for the nabla plugin.
            -- We need to disable TS on latex documents only
            disable = function(_lang, _buf)
                -- Disable if language is latex
                if (_lang == "latex")   or
                    (_lang == "tex")    or
                    (_lang == "bib")    or
                    (_lang == "plaintex")
                then
                    return true
                end
            end,
            additional_vim_regex_highlighting = false,
        },

        -- Enable incremental selection
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },

        -- Enable TS to do indentation
        indent = {
            enable = true,
        },
        sync_install = true,
    },
}

return M
