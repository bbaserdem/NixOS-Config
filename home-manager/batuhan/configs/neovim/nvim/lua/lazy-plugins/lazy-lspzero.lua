-------------------------------------------------
-- name : LSP Zero
-- url  : https://github.com/VonHeikemen/lsp-zero.nvim
-------------------------------------------------
-- Collection of functions that help with LSP setup

local M = {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
    },
    branch = "v3.x",
}

return M
