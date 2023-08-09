return {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
        {
            'hrsh7th/cmp-nvim-lsp',
            dependencies = {
                'rafamadriz/friendly-snippets',
            }
        },
        'saadparwaiz1/cmp_luasnip',
    },
    opts = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        return {
            mapping = cmp.mapping.preset.insert({
                ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior
                    .Insert }),
                ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior
                    .Insert }),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.abort(),
                -- When having a snippet, tab allows to jump to next prompt
                ['<CR>'] = cmp.mapping.confirm({ select = true }),

            }),
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' } },
                { { name = 'buffer' }, }),
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
        }
    end
}
