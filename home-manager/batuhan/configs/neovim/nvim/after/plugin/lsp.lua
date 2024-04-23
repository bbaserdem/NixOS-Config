-- nvim/after/plugin/lsp.lua

local on_attach = function(_, bufnr)
    -- Keybinding function
    local bufmap = function(keys, func)
        vim.keymap.set("n", keys, func, { buffer = bufnr })
    end

    bufmap("<leader>r", vim.lsp.buf.rename)
    bufmap("<leader>a", vim.lsp.buf.code_action)

    bufmap("gd", vim.lsp.buf.definition)
    bufmap("gD", vim.lsp.buf.declaration)
    bufmap("gI", vim.lsp.buf.implementation)
    bufmap("<leader>D", vim.lsp.buf.type_definition)

    bufmap("gr", require("telescope.builtin").lsp_references)
    bufmap("<leader>s", require("telescope.builtin").lsp_document_symbols)
    bufmap("<leader>S", require("telescope.builtin").lsp_dynamic_workspace_symbols)
    
    bufmap("K", vim.lsp.buf.hover)

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, {})
end

-- Load cmp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Force load neodev if the path contains our NixOS configuration
require("neodev").setup({
    override = function(root_dir, library)
        if root_dir:find("configs/neovim/nvim", 1, true) then
            library.enabled = true
            library.plugins = true
        end
    end,
})
require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    Lua = {
        workspace = { checkThirdParty = false, },
        telemetry = { enable = false, },
    },
}
