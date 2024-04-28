-------------------------------------------------
-- name : Nvim Obsidian
-- url  : https://github.com/epwalsh/obsidian.nvim
-------------------------------------------------
-- Neovim plugin for writing obsidian vaults.

local M = {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
        "epwalsh/pomo.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "Work - CSHL",
                path = "~/Media/Notes/CSHL",
            }, {
                name = "NixOS",
                path = "~/Media/Notes/NixOS",
            },
        },
    },
}

return M
