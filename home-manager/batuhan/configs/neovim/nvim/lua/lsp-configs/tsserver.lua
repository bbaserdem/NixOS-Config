-- Typescript LSP config

-- Load cmp capabilities
local lspc = require("lsp-common")

require("lspconfig").ts_ls.setup({
    capabilities = lspc.capabilities_with_cmp,
})
