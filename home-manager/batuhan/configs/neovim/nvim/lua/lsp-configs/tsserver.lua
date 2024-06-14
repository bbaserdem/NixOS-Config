-- Typescript LSP config

-- Load cmp capabilities
local lspc = require("lsp-common")

require("lspconfig").tsserver.setup({
    capabilities = lspc.capabilities_with_cmp,
})
