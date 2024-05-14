-- nvim/after/ftplugin/lu.lua
-- Lua lsp config

-- Load cmp capabilities
local lspc = require("lsp-common")

require("lspconfig").nixd.setup {
    -- on_attach = <function>,
    capabilities = lspc.capabilities_with_cmp,
}
