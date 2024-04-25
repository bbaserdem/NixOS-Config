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
            "lua", "luadoc", "lua patterns", "vim", "vimdoc",
            "nix",
            "git_config", "git_rebase",
            "gitattributes",
            "gitcommit",
            "gitignore",
            "regex"
        },
        sync_install = true,
    },
}

return M
