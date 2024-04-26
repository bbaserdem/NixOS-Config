-------------------------------------------------
-- name : Nvim Scrollbar
-- url  : https://github.com/petertriho/nvim-scrollbar
-------------------------------------------------
-- Scrollbar showing diagnostic locations

local M = {
    "petertriho/nvim-scrollbar",
    dependencies = {
        "lewis6991/gitsigns.nvim",
        --"kevinhwang91/nvim-hlslens",
    },
    lazy = false,
    opts = {
        show = true,
        handlers = {
            gitsigns = true,
            -- search = true,
        },
    },
}

return M
