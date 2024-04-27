-------------------------------------------------
-- name : Mason
-- url  : https://github.com/williamboman/mason.nvim
-------------------------------------------------
-- Local LSP, DAP, linter and formatter installer and manager
-- Disabled in favor of nix package management

local M = {
    "williamboman/mason.nvim",
    enabled = false,
    opts = {
        PATH = "skip",
    },
}

return M
