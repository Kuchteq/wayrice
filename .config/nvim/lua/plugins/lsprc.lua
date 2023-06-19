LSP_ON_ATTACH_BASE_SETUP = function(client, _)
	-- e as in error
	vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
	vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
	vim.keymap.set('n', ']a', vim.lsp.buf.code_action, {})
	vim.keymap.set('n', '[a', vim.lsp.buf.code_action, {})
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})

	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true })
	-- o as in foooormat
	vim.keymap.set('n', '<leader>o', function() vim.lsp.buf.format({ tabSize = 1 }) end)
	-- tell lsp not to provide their lousy syntax highlighting
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
		{ "▔",  "FloatBorder" },
		{ "🭾", "FloatBorder" },
		{ "▕",  "FloatBorder" },
		{ "🭿", "FloatBorder" },
		{ "▁",  "FloatBorder" },
		{ "🭼", "FloatBorder" },
		{ "▏",  "FloatBorder" },
	}

	local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or border
		return orig_util_open_floating_preview(contents, syntax, opts, ...)
	end

	-- lsp autocompletion
	local capabilities = require('cmp_nvim_lsp').default_capabilities()


	require("lspconfig").ltex.setup {
		on_attach = function(_, _)
			LSP_ON_ATTACH_BASE_SETUP()
			-- the ltex extra sets up some necessities such as disabling rules and adding stuff to custom dictionary
			require("ltex_extra").setup {
				load_langs = { "en-US" }, -- table <string> : languages for witch dictionaries will be loaded
				init_check = true, -- boolean : whether to load dictionaries on startup
				path = "./additional_dics", -- string : path to store dictionaries. Relative path uses current working directory
				log_level = "error", -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
			}
		end,
		settings = {
			ltex = {
				language = "en-US", }
		}
	}
	require("neodev").setup({})
	require('lspconfig').lua_ls.setup({
		on_attach = LSP_ON_ATTACH_BASE_SETUP,
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

	require("lspconfig").pyright.setup { on_attach = LSP_ON_ATTACH_BASE_SETUP, capabilities = capabilities }
	require("lspconfig").clangd.setup { on_attach = LSP_ON_ATTACH_BASE_SETUP, capabilities = capabilities }
	require("lspconfig").bashls.setup { on_attach = LSP_ON_ATTACH_BASE_SETUP, capabilities = capabilities }
	require("lspconfig").tsserver.setup { on_attach = LSP_ON_ATTACH_BASE_SETUP, capabilities = capabilities }
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
