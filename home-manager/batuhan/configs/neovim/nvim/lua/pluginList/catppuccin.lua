-------------------------------------------------
-- name : catppuccin for nvim
-- url  : https://github.com/catppuccin/nvim
---------------------------------------------------
-- Comment out blocks of text
--local wk = require("which-key")

local M = {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = { -- :h background
            light = "latte",
            dark = "macchiato",
        },
    },
    config = function(_plugin, _opts)
        require("catppuccin").setup(_opts)
        vim.cmd("colorscheme catppuccin")
    end,
}

return M
