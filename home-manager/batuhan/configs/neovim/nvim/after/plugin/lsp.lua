-- nvim/after/plugin/lsp.lua
-- Generic lsp config

local on_attach = function(_, bufnr)
    -- Keybinding function
    local bufmap = function(_keys, _func, _desc)
        vim.keymap.set("n", _keys, _func, {
            buffer = bufnr,
            desc = _desc,
        })
    end

    bufmap("<leader>lr", vim.lsp.buf.rename, "LSP rename")
    bufmap("<leader>la", vim.lsp.buf.code_action, "LSP code action")

    bufmap("<leader>ld", vim.lsp.buf.definition,
        "LSP definition")
    bufmap("<leader>lD", vim.lsp.buf.type_definition,
        "LSP type definition")
    bufmap("<leader>li", vim.lsp.buf.declaration,
        "LSP declaration")
    bufmap("<leader>lI", vim.lsp.buf.implementation,
        "LSP implementation")

    bufmap("<leader>lt", require("telescope.builtin").lsp_references,
        "LSP references")
    bufmap("<leader>ls", require("telescope.builtin").lsp_document_symbols,
        "LSP symbols")
    bufmap("<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols,
        "LSP symbols (workspace)")
    
    bufmap("K", vim.lsp.buf.hover, "LSP hover menu")

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, {})
end

-- Load cmp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    Lua = {
        workspace = { checkThirdParty = false, },
        telemetry = { enable = false, },
    },
}
