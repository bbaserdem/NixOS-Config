-------------------------------------------------
-- name : Indent Blankline
-- url  : https://github.com/lukas-reineke/indent-blankline.nvim
-------------------------------------------------
-- Decorates indentation levels

-- Local highlight groups used to color indentlines
local M = {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "HiPhish/rainbow-delimiters.nvim",
    },
    lazy = false,
    config = true,
}

return M
