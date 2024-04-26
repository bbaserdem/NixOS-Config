-------------------------------------------------
-- name : Aerial
-- url  : https://github.com/stevearc/aerial.nvim
-------------------------------------------------
-- Outlines all the symbols used in the document

local M = {
    "stevearc/aerial.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        backends = {
            "lsp",
            "treesitter",
            "markdown",
            "asciidoc",
            "man",
        },
        layout = {
            max_width = { 40, 0.2 },
            min_width = 20,
        },
        default_direction = "right",
        resize_to_content = true,
        attach_mode = "global",
        show_guides = true,
    },
}

return M
