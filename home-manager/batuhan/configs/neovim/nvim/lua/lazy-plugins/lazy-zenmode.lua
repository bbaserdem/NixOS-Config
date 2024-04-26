-------------------------------------------------
-- name : Zen Mode
-- url  : https://github.com/folke/zen-mode.nvim
-------------------------------------------------
-- Removes distractions by focusing only the current text

local M = {
    "folke/zen-mode.nvim",
    dependencies = {
        "folke/twilight.nvim",
    },
    opts = {
        window = {
            options = {
                signcolumn = "no", -- disable signcolumn
                number = false, -- disable number column
                relativenumber = false, -- disable relative numbers
                cursorline = false, -- disable cursorline
                cursorcolumn = false, -- disable cursor column
                -- foldcolumn = "0", -- disable fold column
                list = false, -- disable whitespace characters
            }
        },
        plugins = {
            twilight = { enabled = true },
            gitsigns = { enabled = false },
            tmux = { enabled = false },
            kitty = {
                enabled = true,
                font = "+2",
            },
        },
    },
}

return M
