-- nvim/lua/pluginlist.lua
-- List of plugins. Any further complicated setup should happen in nvim/after/plugins

return {
    -- Color theme gruvbox
    {   "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function(_plugin, _opts)
            require("gruvbox").setup(_opts)
            vim.cmd("colorscheme gruvbox")
        end,
    },
    -- LSP config
    "neovim/nvim-lspconfig",
    "folke/neodev.nvim",
    -- Lualine
    {   "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            options = {
                icons_enabled = true,
                theme = "gruvbox",
            },
        },
    },
    -- Comments
    {   "numToStr/Comment.nvim",
        lazy = false,
    },
    -- Completion
    {   "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            -- Completion sources
            "hrsh7th/cmp-nvim-lsp",
        },
    },
}
