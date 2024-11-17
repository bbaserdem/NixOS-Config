-------------------------------------------------
-- name : Telescope
-- url  : https://github.com/nvim-telescope/telescope.nvim
-------------------------------------------------
-- Extendable fuzzy finder for lists

local M = {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-fzf-native.nvim",
    },
    branch = "0.1.x",
    -- For nvim notify
    lazy = false,
    opts = {
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
        },
    },
    config = function(_lazyplug, _opts)
        local tel = require("telescope")
        tel.setup(_opts)
        -- Load fuzzyfinder plugin too
        tel.load_extension("fzf")
    end,
}

return M
