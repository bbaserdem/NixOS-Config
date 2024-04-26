-------------------------------------------------
-- name : Nvim Notify
-- url  : https://github.com/rcarriga/nvim-notify
-------------------------------------------------
-- Functions to manipulate code commenting

local M = {
    "rcarriga/nvim-notify",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    lazy = false,
    opts = {
        mappings = false,
        top_down = true,
        render = "compact",
        stages = "fade_in_slide_out",
    },
    main = "notify",
    config = function(_plug, _opts)
        local _notify = require("notify")
        -- Initialize, then setup as default notification handler
        _notify.setup(_opts)
        vim.notify = _notify
    end,
}

return M
