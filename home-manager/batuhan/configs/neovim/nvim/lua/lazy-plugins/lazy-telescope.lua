-------------------------------------------------
-- name : Telescope
-- url  : https://github.com/nvim-telescope/telescope.nvim
-------------------------------------------------
-- Extendable fuzzy finder for lists

local M = {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-fzf-native.nvim",
    },
    branch = "0.1.x",
    -- For nvim notify
    lazy = false,
}

return M
