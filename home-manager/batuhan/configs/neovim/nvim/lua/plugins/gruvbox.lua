-------------------------------------------------
-- name : Gruvbox for nvim
-- url  : https://github.com/ellisonleao/gruvbox.nvim
---------------------------------------------------
-- Comment out blocks of text
--local wk = require("which-key")

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
