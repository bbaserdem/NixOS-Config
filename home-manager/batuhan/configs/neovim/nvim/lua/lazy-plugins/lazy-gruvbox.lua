-------------------------------------------------
-- name : Gruvbox
-- url  : https://github.com/ellisonleao/gruvbox.nvim
-------------------------------------------------
-- Color theme with tree-sitter support

local M = {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function(_plugin, _opts)
        require("gruvbox").setup(_opts)
        vim.cmd("colorscheme gruvbox")
    end,
}

return M
