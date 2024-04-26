-------------------------------------------------
-- name : Git Signs
-- url  : https://github.com/lewis6991/gitsigns.nvim
-------------------------------------------------
-- Decorates sidebar, and allows selective git commands to blocks

local M = {
    "lewis6991/gitsigns.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
    },
    lazy = false,
}

return M
