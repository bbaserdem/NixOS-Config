-------------------------------------------------
-- name : VimTex
-- url  : https://github.com/lervag/vimtex
-------------------------------------------------
-- LaTeX integration beyond LSP functionality, mostly inverse search

local M = {
    "lervag/vimtex",
    -- Instead of not lazy loading, just load us on conditions
    ft = { "latex", "tex", "bib", },
    cmd = "VimtexInverseSearch",
    dependencies = {
    },
    -- We are a vim plugin
    init = function()
        -- Will provide own keybindings
        vim.g.vimtex_mappings_enabled = 0
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_progname = "nvr"
        vim.g.vimtex_quickfix_method = "pplatex"
        vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
        vim.g.vimtex_quickfix_ignore_filters = {
            "Underfull",
            "Overfull",
            "Float too large",
            "Package siunitx Warning",
        }
    end,
}

return M
