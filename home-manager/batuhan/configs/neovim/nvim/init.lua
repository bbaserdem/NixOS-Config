--[[
    _   __      _              ______            _____
   / | / _   __(_____ ___     / ________  ____  / __(_____ _
  /  |/ | | / / / __ `__ \   / /   / __ \/ __ \/ /_/ / __ `/
 / /|  /| |/ / / / / / / /  / /___/ /_/ / / / / __/ / /_/ /
/_/ |_/ |___/_/_/ /_/ /_/   \____/\____/_/ /_/_/ /_/\__, /
                                                   /____/
--]]

-- Do framebuffer detection
if vim.env.TERM == 'linux' then
    vim.g.isFramebuffer = true
else
    vim.g.isFramebuffer = false
end

-- Set leader key, other plugins need this ASAP
-- The plugin which-key needs this setup ASAP
local keymap = vim.api.nvim_set_keymap
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load plugin manager first, since which-key depends on the plugins
require("lazy-init")

-- Load our own options
require("options")

-- Load common lsp commands own options
require("lsp-common")
