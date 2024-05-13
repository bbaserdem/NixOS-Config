-------------------------------------------------
-- name : Nvim Tree
-- url  : https://github.com/nvim-tree/nvim-tree.lua
-------------------------------------------------
-- Functions to manipulate code commenting

local M = {
    "nvim-tree/nvim-tree.lua",
    -- Need to reenable netrw to download spell dicts
    enabled = true,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        hijack_cursor = true,
        hijack_netrw = true,
        sync_root_with_cwd = true,
        view = {
            side = "left",
            width = {
                min = 10,
                max = 40,
                padding = 2,
            },
        },
        modified = {
            enabled = true,
        },
        filters = {
            git_ignored = false,
            custom = {
                "^\\.git$",
                "\\.aux$",
                "\\.bbl$",
                "\\.bcf$",
                "\\.blg$",
                "\\.fdb_latexmk$",
                "\\.fls$",
                "\\.out$",
                "\\.run.xml$",
                "\\.synctex\\.gz$",
            },
        },
        trash = {
            cmd = "trash",
        },
    },
}

return M
