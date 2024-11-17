-------------------------------------------------
-- name : Lualine
-- url  : https://github.com/nvim-lualine/lualine.nvim
-------------------------------------------------
-- More informative infobar

local M = {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    opts = {
        options = {
            icons_enabled = true,
            theme = "gruvbox",
        },
    },
}

return M
