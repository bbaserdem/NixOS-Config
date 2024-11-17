-------------------------------------------------
-- name : Indent Blankline
-- url  : https://github.com/lukas-reineke/indent-blankline.nvim
-------------------------------------------------
-- Decorates indentation levels

local M = {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
}

return M
