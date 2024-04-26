-------------------------------------------------
-- name : Toggleterm
-- url  : https://github.com/akinsho/toggleterm.nvim
-------------------------------------------------
-- Persistent terminal from within neovim

local M = {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
        autochdir = true,
        close_on_exit = false,
    },
}

return M
