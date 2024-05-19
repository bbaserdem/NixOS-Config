-- nvim/after/ftplugin/lu.lua
-- Lua lsp config

-- Load cmp capabilities
local lspc = require("lsp-common")

require("lspconfig").nixd.setup({
    cmd = { "nixd" },
    -- on_attach = <function>,
    capabilities = lspc.capabilities_with_cmp,
    -- Global config options
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import (builtins.getFlake \"/home/batuhan/Projects/NixOS\").inputs.nixpkgs { }",
            },
            formatting = {
                command = { "nix", "fmt" },
            },
            options = {
                nixos = {
                    expr = "builtins.getFlake \"/home/batuhan/Projects/NixOS\").nixosConfigurations.yel-ana.options"
                },
                ["home-manager"] = {
                    expr = "builtins.getFlake \"/home/batuhan/Projects/NixOS\").homeConfigurations.\"batuhan@yel-ana\".options"
                },
            },
        },
    },
})
