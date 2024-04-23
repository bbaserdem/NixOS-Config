-------------------------------------------------
-- name : Lualine for nvim
-- url  : https://github.com/nvim-lualine/lualine.nvim
---------------------------------------------------
-- Comment out blocks of text
--local wk = require("which-key")

local M = {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons"
    },
    opts = {
        options = {
            icons_enabled = true,
            theme = "gruvbox",
        },
    },
}

return M
