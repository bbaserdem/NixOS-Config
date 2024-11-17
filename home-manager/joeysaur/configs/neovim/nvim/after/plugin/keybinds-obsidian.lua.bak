-- Obsidian keybindings
-- nvim/after/plugin/keybinds.lua
local wk = require("which-key")
local ob = require("obsidian")

-- Normmal mode keybinds
wk.register({
    o = {
        name = "Obsidian",
        ["<Space>"] = { ob.commands.open,
            "Open obsidian",
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",
    silent = true,
})
