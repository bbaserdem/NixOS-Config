-------------------------------------------------
-- name : Telescope FZF native
-- url  : https://github.com/nvim-telescope/telescope-fzf-native.nvim
-------------------------------------------------
-- Pure C implementation of fzf to be used with telescope search

local M = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
}

return M
