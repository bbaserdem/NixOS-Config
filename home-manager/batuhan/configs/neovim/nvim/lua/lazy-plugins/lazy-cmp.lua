-------------------------------------------------
-- name : Nvim CMP
-- url  : https://github.com/hrsh7th/nvim-cmp
-------------------------------------------------
-- Autocompletion engine

local M = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        -- Snippet engine
        "L3MON4D3/LuaSnip",
        -- Completion sources
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp"
    },
}

return M