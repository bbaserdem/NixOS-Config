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
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = {
            "bash", "make", "ini", "json", "toml",
            "c", "python",
            "lua", "luadoc", "luap", "vim", "vimdoc", "markdown", "latex",
            "nix",
            "git_config", "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "regex"
        },
        -- Treesitter with latex causes vimtex to malfunction
        -- however, I still want to use latex ts highlighter in markdown
        -- for the nabla plugin.
        -- We need to disable TS on latex documents only
        highlight = {
            enable = true,
            disable = function(_lang, _buf)
                -- Disable if language is latex
                if (_lang == "latex") or (_lang == "tex") or (_lang == "bib") then
                    return true
                end
            end,
        },
        sync_install = true,
    },
}

return M
