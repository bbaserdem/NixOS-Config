-- General completion
-- nvim/after/plugin/cmp.lua

local cmp = require("cmp")
local luasnip = require("luasnip")

-- Needed for friendly snippets
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup{}

-- Function to check if the cursor has text before it
local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Completion engine setup
cmp.setup {
    -- Snippets engine
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    -- Key mappings
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping({
            i = function (fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    })
                else
                    fallback()
                end
            end,
            s = cmp.confirm({ select = true, }),
            c = cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
        }),
        ["<Tab>"] = cmp.mapping( function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s", } ),
        ["<S-Tab>"] = cmp.mapping( function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.expand_or_locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s", } ),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "spell", 
            option = {
                keep_all_entries = false,
                enable_in _context = function()
                    return require("cmp.config.context").in_treesitter_capture("spell")
                end,
            },
        },
    },
}
