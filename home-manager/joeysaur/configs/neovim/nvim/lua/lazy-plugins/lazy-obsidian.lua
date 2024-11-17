-------------------------------------------------
-- name : Nvim Obsidian
-- url  : https://github.com/epwalsh/obsidian.nvim
-------------------------------------------------
-- Neovim plugin for writing obsidian vaults.

local M = {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
        "BufReadPre " .. vim.fn.expand "~" .. "Media/Notes/*.md",
        "BufNewFile " .. vim.fn.expand "~" .. "Media/Notes/*.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
        "epwalsh/pomo.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "Personal",
                path = "~/Media/Notes",
            },
        },
        daily_notes = {
            folder = "Daily Notes",
            date_format = "%Y_%m_%d",
            --alias_format = "%B %-d, %Y",
            --template = nil,
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        mappings = {},
    },
}

return M
