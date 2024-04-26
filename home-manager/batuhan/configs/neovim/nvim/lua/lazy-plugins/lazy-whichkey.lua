-------------------------------------------------
-- name : Which Key
-- url  : https://github.com/folke/which-key.nvim
-------------------------------------------------
-- Functions to manipulate code commenting

local M = {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        -- vim.o.timeoutlen = 300 -- This is set in opts
    end,
    opts = {
        marks = true,
        registers = true,
        -- Show WhichKey at z= to select spelling suggestions
        spelling = {
            enabled = true,
            suggestions = 10,
        },
        window = {
            border = "rounded",
            position = "bottom",
            margin = { 1, 0, 1, 0 },
            padding = { 1, 2, 1, 2 },
        },
    },
}

return M
