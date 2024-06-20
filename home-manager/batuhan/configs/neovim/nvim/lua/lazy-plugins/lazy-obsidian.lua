-------------------------------------------------
-- name : Nvim Obsidian
-- url  : https://github.com/epwalsh/obsidian.nvim
-------------------------------------------------
-- Neovim plugin for writing obsidian vaults.

local M = {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
        "epwalsh/pomo.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "Work - CSHL",
                path = "~/Media/Notes/CSHL",
                strict = true,
            }, {
                name = "Personal",
                path = "~/Media/Notes/Personal",
                strict = true,
            },
        },
        daily_notes = {
            folder = "Daily_Notes",
            date_format = "%Y-%m-%d",
            alias_format = "%B %-d, %Y",
            template = nil,
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        mappings = {},
    },
}

return M
