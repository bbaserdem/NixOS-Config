-------------------------------------------------
-- name : Nvim Obsidian
-- url  : https://github.com/epwalsh/pomo.nvim
-------------------------------------------------
-- Pomodoro timer for nvim

local M = {
    "epwalsh/pomo.nvim",
    version = "*",
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat", },
    dependencies = {
        "rcarriga/nvim-notify",
    },
    opts = {
        notifiers = {
            {
                name = "Default",
                opts = {
                    sticky = true,
                    title_icon = "󱎫",
                    text_icon = "󰄉",
                },
            },
            { name = "System", }
        },
    },
}

return M
