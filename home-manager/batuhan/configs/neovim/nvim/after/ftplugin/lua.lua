-- nvim/after/ftplugin/lu.lua
-- Lua lsp config

-- Load cmp capabilities
local lsp_common = require("lsp-common")

require("lspconfig").lua_ls.setup {
    -- on_attach = <function>,
    capabilities = lsp_common.capabilities_with_cmp,
    Lua = {
        workspace = { checkThirdParty = false, },
        telemetry = { enable = false, },
    },
}
