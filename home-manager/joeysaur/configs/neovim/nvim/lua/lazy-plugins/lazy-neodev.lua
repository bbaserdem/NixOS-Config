-------------------------------------------------
-- name : Neodev
-- url  : https://github.com/folke/neodev.nvim
-------------------------------------------------
-- Configures lua_language_server for nvim config files

local M = {
    "folke/neodev.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    -- Load neodev if the path contains our NixOS configuration
    ft = { "lua", },
    lazy = false,
    opts = {
        -- Override directory detection to edit files in flake
        override = function(_rootdir, _library)
            if _rootdir:find("configs/neovim/nvim", 1, true) then
                _library.enabled = true
                _library.plugins = true
            end
        end,
        -- This makes loading faster with lls >3.6.0
        pathStrict = true,
    },
}

return M
