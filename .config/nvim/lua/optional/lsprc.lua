vim.lsp.enable({
        'clangd',
        'gopls',
        'luals',
        'bashls',
        'typython',
        'ts_ls',
        'rust_analyzer'
})

vim.keymap.set('n', 'ö', function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set('n', 'ü', function() vim.diagnostic.jump({ count = -1, float = true }) end)
vim.keymap.set('n', 'ę', vim.lsp.buf.code_action)
vim.keymap.set('n', 'Ę', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>o', function() vim.lsp.buf.format { async = true } end)
vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation()  end)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename)

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
        return hover({
                border = "single",
                max_width = math.floor(vim.o.columns * 0.7),
                max_height = math.floor(vim.o.lines * 0.7),
        })
end


vim.diagnostic.config({
        float = {
                style = "minimal",
                border = "single"
        },
})

return {}
-- local chosenLang = "en-US"
--
-- local startLtex = function()
--         vim.ui.input({ prompt = '<enter> for German, e for English, p for Polish: ' }, function(input)
--                 if input == '' then
--                         chosenLang = "de-DE"
--                 elseif input == "p" then
--                         chosenLang = "pl-PL"
--                 end
--         end)
--
--         require("lspconfig").ltex.setup {
--                 on_attach = function(_, _)
--                         -- the ltex extra sets up some necessities such as disabling rules and adding stuff to custom dictionary
--                         require("ltex_extra").setup {
--                                 load_langs = {}, -- table <string> : languages for witch dictionaries will be loaded
--                                 init_check = false, -- boolean : whether to load dictionaries on startup
--                                 path = "./additional_dics", -- string : path to store dictionaries. Relative path uses current working directory
--                                 log_level = "error", -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
--                         }
--                 end,
--                 settings = {
--                         ltex = {
--                                 language = chosenLang }
--                 }
--         }
--         require("lspconfig").ltex.launch()
-- end
--
-- -- e as in error
-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
--
-- vim.keymap.set('n', '<leader>d', function() if vim.diagnostic.is_enabled() then vim.diagnostic.enable(false) else vim.diagnostic.enable() end end)
-- vim.keymap.set('n', '<leader>l', startLtex)
--
-- vim.api.nvim_create_autocmd('LspAttach', {
--         group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--         callback = function(ev)
--                 local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
--                 local next_diagnostic, prev_diagnostic = ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
--                 vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
--                 vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
--                 vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
--                 vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
--                 vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
--                 vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
--
--                 vim.keymap.set('n', ']e', next_diagnostic, { remap = true })
--                 vim.keymap.set('n', '[e', prev_diagnostic)
--
--                 -- Enable completion triggered by <c-x><c-o>
--                 -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
--
--                 -- Buffer local mappings.
--                 -- See `:help vim.lsp.*` for documentation on any of the below functions
--                 local opts = { buffer = ev.buf }
--                 vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--                 -- vim.keymap.set('n', 'gd',  vim.lsp.buf.definition, opts)
--                 vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
--                 vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, opts)
--                 vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
--                 vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--                 -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--                 vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
--                 vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
--                 vim.keymap.set('n', '<space>wl', function()
--                         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--                 end, opts)
--                 vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
--                 vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
--                 vim.keymap.set('n', '<c-.>', vim.lsp.buf.code_action, {})
--                 -- o as in foooormat
--                 vim.keymap.set('n', '<leader>o', function()
--                         vim.lsp.buf.format { async = true }
--                 end, opts)
--         end,
-- })
--
-- local disable_lsp_highlighting = function(client, _)
--         client.server_capabilities.semanticTokensProvider = nil
-- end
--
-- local function setUpLsp()
--         require("mason").setup()
--         require("mason-lspconfig").setup({
--                 ensure_installed = { "ltex", "pyright", "bashls", "gopls" },
--                 automatic_installation = true
--         })
--
--         -- ensuring we have a nice border around hover definitions
--         local border = {
--                 { "🭽", "FloatBorder" },
--                 { "▔", "FloatBorder" },
--                 { "🭾", "FloatBorder" },
--                 { "▕", "FloatBorder" },
--                 { "🭿", "FloatBorder" },
--                 { "▁", "FloatBorder" },
--                 { "🭼", "FloatBorder" },
--                 { "▏", "FloatBorder" },
--         }
--
--         local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
--
--         function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--                 opts = opts or {}
--                 opts.border = opts.border or border
--                 return orig_util_open_floating_preview(contents, syntax, opts, ...)
--         end
--
--         -- lsp autocompletion
--         local capabilities = require('cmp_nvim_lsp').default_capabilities()
--
--
--         require("neodev").setup({})
--         require('lspconfig').lua_ls.setup({
--                 on_attach = disable_lsp_highlighting,
--                 settings = {
--                         Lua = {
--                                 workspace = {
--                                         checkThirdParty = false,
--                                 },
--                                 format = {
--                                         enable = true,
--                                         defaultConfig = {
--                                                 max_line_length = "unset"
--                                         }
--                                 }
--                         }
--                 }
--         })
--
--         require("lspconfig").pyright.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
--         require("lspconfig").clangd.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
--         require("lspconfig").gopls.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
--         require("lspconfig").bashls.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
--         require("lspconfig").html.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
--         require("lspconfig").ts_ls.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
--         require("lspconfig").svelte.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
--         require 'lspconfig'.sqls.setup {
--                 on_attach = function(client, bufnr)
--                         disable_lsp_highlighting(client)
--                         require('sqls').on_attach(client, bufnr)
--                 end,
--         }
-- end
--
-- return {
--         "neovim/nvim-lspconfig",
--         event = { "BufReadPre", "BufNewFile" },
--         dependencies = {
--                 "williamboman/mason.nvim",
--                 "williamboman/mason-lspconfig.nvim",
--                 "barreiroleo/ltex_extra.nvim",
--                 "folke/neodev.nvim",
--                 "nanotee/sqls.nvim",
--         },
--         config = setUpLsp
-- }
