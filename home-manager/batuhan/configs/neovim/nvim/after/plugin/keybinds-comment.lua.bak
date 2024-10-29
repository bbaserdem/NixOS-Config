-- Global keybindings, using which-key to organize
-- nvim/after/plugin/keybinds.lua
local wk = require("which-key")
local ca = require("Comment.api")

-- Normal mode keybinds
wk.register({
    c = {
        name = "Comment",
        ["<Space>"] = { ca.toggle.linewise.current,
            "Toggle current line",
        },
        x = { ca.comment.linewise.current,
            "Comment current line",
        },
        X = { ca.comment.blockwise.current,
            "Comment current line as a block",
        },
        c = { function() ca.call("toggle.linewise", "g@") end,
            "Toggle lines with motion",
        },
        C = { function() ca.call("comment.linewise", "g@") end,
            "Comment lines with motion",
        },
        --[[
        b = { function() ca.call("toggle.blockwise", "g@") end,
            "Toggle lines as a block with motion",
        },
        B = { function() ca.call("comment.blockwise", "g@") end,
            "Comment lines as a block with motion",
        },
        --]]
        o = { ca.insert.linewise.below,
            "Add new comment to next line",
        },
        O = { ca.insert.linewise.above,
            "Add new comment to prev line",
        },
        p = { ca.insert.blockwise.below,
            "Add new comment block to next line",
        },
        P = { ca.insert.blockwise.above,
            "Add new comment block to prev line",
        },
        a = { ca.insert.linewise.eol,
            "Append new comment at the end of this line",
        },
        A = { ca.insert.blockwise.eol,
            "Append new comment block at the end of this line",
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",
    silent = true,
})
