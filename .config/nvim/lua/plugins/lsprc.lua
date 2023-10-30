local chosenLang = "en-US"

local startLtex = function()
    -- if #vim.lsp.get_clients() > 0 then
    --     vim.ui.input({ prompt = 'Change to some other languages todo' }, function(input)
    --         if input == '' then
    --             chosenLang = "de-DE"
    --         end
    --     end)
    -- end
    vim.ui.input({ prompt = '<enter> for German, e for English: ' }, function(input)
        if input == '' then
            chosenLang = "de-DE"
        end
    end)

    require("lspconfig").ltex.setup {
        on_attach = function(_, _)
            -- the ltex extra sets up some necessities such as disabling rules and adding stuff to custom dictionary
            require("ltex_extra").setup {
                load_langs = {},            -- table <string> : languages for witch dictionaries will be loaded
                init_check = false,         -- boolean : whether to load dictionaries on startup
                path = "./additional_dics", -- string : path to store dictionaries. Relative path uses current working directory
                log_level = "error",        -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
            }
        end,
        settings = {
            ltex = {
                language = chosenLang }
        }
    }
    require("lspconfig").ltex.launch()
end

-- e as in error
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', ']e', vim.diagnostic.goto_next, { remap = true })
vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>d', function() if vim.diagnostic.is_disabled() then vim.diagnostic.enable() else vim.diagnostic.disable() end end)
vim.keymap.set('n', '<leader>l', startLtex)

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        -- vim.keymap.set('n', 'gd',  vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gd',  require('telescope.builtin').lsp_definitions, opts)
        vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, opts)
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', ']a', vim.lsp.buf.code_action, {})
        vim.keymap.set('n', '[a', vim.lsp.buf.code_action, {})
        -- o as in foooormat
        vim.keymap.set('n', '<leader>o', function()
            vim.lsp.buf.format({ tabSize = 1, async = true })
        end, opts)
    end,
})

local disable_lsp_highlighting = function(client, _)
    client.server_capabilities.semanticTokensProvider = nil
end

local function setUpLsp()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "ltex", "pyright", "bashls", "tsserver" },
        automatic_installation = true
    })

    -- ensuring we have a nice border around hover definitions
    local border = {
        { "🭽", "FloatBorder" },
        { "▔", "FloatBorder" },
        { "🭾", "FloatBorder" },
        { "▕", "FloatBorder" },
        { "🭿", "FloatBorder" },
        { "▁", "FloatBorder" },
        { "🭼", "FloatBorder" },
        { "▏", "FloatBorder" },
    }

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    -- lsp autocompletion
    local capabilities = require('cmp_nvim_lsp').default_capabilities()


    require("neodev").setup({})
    require('lspconfig').lua_ls.setup({
        on_attach = disable_lsp_highlighting,
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        max_line_length = "unset"
                    }
                }
            }
        }
    })

    -- require("lspconfig").pyright.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
    require("lspconfig").clangd.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
    require("lspconfig").gopls.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
    require("lspconfig").bashls.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
    require("lspconfig").html.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
    require("lspconfig").tsserver.setup { on_attach = disable_lsp_highlighting, capabilities = capabilities }
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "barreiroleo/ltex_extra.nvim",
        "folke/neodev.nvim"
    },
    config = setUpLsp
}
