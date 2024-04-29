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
        -- Filesystem path
        { url = "https://codeberg.org/FelipeLema/cmp-async-path.git" },
        "micangl/cmp-vimtex",       -- Vimtex support

    },
}

return M
