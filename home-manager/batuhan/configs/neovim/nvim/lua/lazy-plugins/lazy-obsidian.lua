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
                path = "~/Media/Notes/Personal",
            },
        },
        daily_notes = {
            folder = "Daily Notes",
            date_format = "%Y_%m_%d",
            default_tags = { "dailynote", },
        },
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        -- No mappings yet
        mappings = {},
        preferred_link_style = "wiki",
        disable_frontmatter = false,
        use_advanced_uri = true,
        open_app_foreground = true,
        -- File picker used
        picker = { name = "telescope.nvim", },
        sort_by = "modified",
        sort_reversed = true,
        open_notes_in = "vsplit",
        -- Attachments
        attachments = { img_folder = "_data/Attachments", },
    },
}

return M
