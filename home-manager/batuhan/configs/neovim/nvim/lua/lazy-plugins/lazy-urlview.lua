-------------------------------------------------
-- name : UrlView
-- url  : https://github.com/axieax/urlview.nvim
-------------------------------------------------
-- Extract and expose urls

local M = {
    "axieax/urlview.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        default_picker = "telescope",
        default_action = "system",
    },
}

return M
