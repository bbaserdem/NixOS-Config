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
        "saadparwaiz1/cmp_luasnip", -- Luasnip sources
        "hrsh7th/cmp-nvim-lsp",     -- LSP sources
        "f3fora/cmp-spell",         -- Spelling suggestions
        "hrsh7th/cmp-path",         -- Filesystem path
    },
}

return M
