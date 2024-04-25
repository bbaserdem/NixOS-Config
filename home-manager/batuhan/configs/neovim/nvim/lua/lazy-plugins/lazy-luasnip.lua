-------------------------------------------------
-- name : LuaSnip
-- url  : https://github.com/L3MON4D3/LuaSnip
-------------------------------------------------
-- Snippet engine written in lua

local M = {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    version = "v2.*",
    build = "make install_jsregexp",
}

return M
