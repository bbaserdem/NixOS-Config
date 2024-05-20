-- nvim/lua/lsp-common.lua
-- Generic lsp config

local M = {}

-- Common keybinds, hooked to LSP attach command
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(_args)
        local bufnr = _args.buf
        -- local client = vim.lsp.get_client_by_id(_args.data.client_id)
        require("which-key").register({
            l = {
                name = "LSP functions",
                r = { vim.lsp.buf.rename,
                    "Rename" },
                a = { vim.lsp.buf.code_action,
                    "code Action" },
                d = { vim.lsp.buf.definition,
                    "Definition" },
                t = { vim.lsp.buf.type_definition,
                    "Type definition" },
                i = { vim.lsp.buf.declaration,
                    "(Info) declaration" },
                u = { vim.lsp.buf.implementation,
                    "(Use) implementation" },
                p = { require("telescope.builtin").lsp_references,
                    "(Pointer) references - list" },
                s = { require("telescope.builtin").lsp_document_symbols,
                    "Symbols - list" },
                w = { require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    "Workspace symbols - list" },
                k = { vim.lsp.buf.hover,
                    "hover menu" },
                f = { vim.lsp.buf.format,
                    "Format", },
            },
        }, {
            prefix = "<leader>",
            buffer = bufnr,
        })
    end,
})

-- Load cmp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities_with_cmp = require('cmp_nvim_lsp').default_capabilities(capabilities)

return M
