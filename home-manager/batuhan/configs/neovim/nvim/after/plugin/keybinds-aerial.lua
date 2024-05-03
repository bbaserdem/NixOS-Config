-- Global keybindings, using which-key to organize
-- nvim/after/plugin/keybinds.lua
local wk = require("which-key")
local ae = require("aerial")

-- Normmal mode keybinds
wk.register({
    a = {
        name = "Aerial (outline)",
        ["<Space>"] = { ae.toggle,
            "Toggle outline menu",
        },
        o = { function() ae.open({focus = false}) end,
            "Open in background",
        },
        O = { ae.open_all,
            "Open for all windows",
        },
        x = { ae.close,
            "Close window",
        },
        X = { ae.close_all,
            "Close all windows",
        },
        n = { ae.next,
            "Jump to next symbol",
        }, n = {
            ae.prev,
            "Jump to prev symbol",
        },
        ["?"] = { ae.info,
            "Debug menu",
        },
        n = { ae.nav_toggle,
            "Toggle navigation menu",
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",
    silent = true,
})
