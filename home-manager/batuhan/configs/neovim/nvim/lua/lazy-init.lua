-------------------------------------------------
-- ==== PLUGIN MANAGER ====
--=
-- name : lazy-nvim
-- url  : https://github.com/folke/lazy.nvim
-------------------------------------------------

-- Bootstrap lazyvim as to github instructions
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "git@github.com:folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- Load plugins
require("lazy").setup("lazy-plugins", {
    -- Plugins SHOULD be lazy-loaded by default
    defaults = { lazy = true, },
    -- lockfile generated after running update.
    lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
    checker = { enabled = true },
    dev = {
        path = vim.fn.stdpath("data") .. "/projects",
        fallback = false,
    },
    git = {
        log = { "-5" },
        url_format = "https://github.com/%s.git",
    },
    performance = {
        cache = { enabled = true, },
        rtp = {
            disabled_plugins = {
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                -- "gzip",
                -- "tarPlugin",
                -- "tohtml",
                -- "tutor",
                -- "zipPlugin",
            },
        },
    },
    debug = false,
})

--[[ Put in our keybind
require("which-key").register({
    l = {
        function()
            require("lazy").home()
        end,
        "Launch (l)azy plugin manager",
    },
}, {
    -- System things
    mode = "n",
    prefix = "<leader>s",
})
--]]
