-- Keybinds for Aerial nvim
-- nvim/after/plugin/keybinds-aerial.lua
local wk = require("which-key")
local ae = require("aerial")

-- Normal mode keybinds
wk.add({
    {-- Group definition
        "<leader>a",
        group = "Aerial (outline)",
    }, {
        "<leader>a<Space>",
        ae.toggle,
        desc = "Toggle outline menu",
    }, {
        "<leader>ao",
        function() ae.open({focus = false}) end,
        desc = "Open in background",
    }, {
        "<leader>ao",
        ae.open_all,
        desc = "Open for all windows",
    }, {
        "<leader>ax",
        ae.close,
        desc = "Close window",
    }, {
        "<leader>aX",
        ae.close_all,
        desc = "Close all windows",
    }, {
        "<leader>an",
        ae.next,
        desc = "Jump to next symbol",
    }, {
        "<leader>aN",
        ae.next,
        desc = "Jump to prev symbol",
    }, {
        "<leader>a?",
        ae.info,
        desc = "Debug menu",
    }, {
        "<leader>a?",
        ae.info,
        desc = "Debug menu",
    }, {
        "<leader>a.",
        ae.nav_toggle,
        desc = "Toggle navigation menu",
    },
})
