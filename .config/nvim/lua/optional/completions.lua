vim.keymap.set("i", "<c-j>", "<esc>o")
return {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = "InsertEnter",
        dependencies = {
                {
                        'hrsh7th/cmp-nvim-lsp',
                },
                'saadparwaiz1/cmp_luasnip',
                'hrsh7th/cmp-nvim-lsp-signature-help',
                "micangl/cmp-vimtex",
                {
                        'L3MON4D3/LuaSnip',
                        config = function()
                                require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                },
        },
        config = function()
                local cmp = require("cmp")
                local ls = require("luasnip")
                vim.keymap.set({ "i", "s" }, "<C-l>", function()  ls.jump(1) end, { silent = true })
                vim.keymap.set({ "i", "s" }, "<C-h>", function() ls.jump(-1) end, { silent = true })
                cmp.setup({
                        mapping = {
                                ['<CR>'] = cmp.mapping.confirm({
                                        behavior = cmp.ConfirmBehavior.Replace,
                                        select = true,
                                }),
                                ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
                                ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' })
                        },
                        snippet = {
                                expand = function(args)
                                        require('luasnip').lsp_expand(args.body)
                                end,
                        },
                        sources = cmp.config.sources({ { name = 'nvim_lsp' }, { name = 'luasnip' }, { name = "nvim_lsp_signature_help" }, { name = 'vimtex', },},
                                { { name = 'buffer' },    }),
                        window = {
                                completion = cmp.config.window.bordered(),
                                documentation = cmp.config.window.bordered(),
                        },
                });
        end
}
