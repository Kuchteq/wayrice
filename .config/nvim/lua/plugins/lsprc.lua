local function setUpLsp()
	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = { "ltex", "pyright", "bash" }
	})


	local on_attach_base = function(client, _)
		-- e as in error
		vim.keymap.set('n', ']e', vim.diagnostic.goto_next)
		vim.keymap.set('n', '[e', vim.diagnostic.goto_prev)
		vim.keymap.set('n', ']a', vim.lsp.buf.code_action, {})
		vim.keymap.set('n', '[a', vim.lsp.buf.code_action, {})
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})

		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true })
		vim.keymap.set('n', '<leader>q', function() vim.lsp.buf.format({ tabSize = 1 }) end)
		-- tell lsp not to provide their lousy syntax highlighting
		client.server_capabilities.semanticTokensProvider = nil
	end

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
			on_attach_base()
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
		on_attach = on_attach_base,
		settings = {
			Lua = {
				completion = { callSnippet = "Replace" },
				format = {
					enable = true,
					defaultConfig = {
						max_line_length = "unset"
					}
				}
			}
		}
	})
	require("lspconfig").pyright.setup { on_attach = on_attach_base, capabilities = capabilities }
	require("lspconfig").clangd.setup { on_attach = on_attach_base, capabilities = capabilities }
	require("lspconfig").bashls.setup { on_attach = on_attach_base, capabilities = capabilities }
	require("flutter-tools").setup { lsp = {
		on_attach = on_attach_base,
		settings = {
			lineLength = 90
		}
	} }
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"barreiroleo/ltex_extra.nvim",
		"Nash0x7E2/awesome-flutter-snippets",
		"folke/neodev.nvim"
	},
	config = setUpLsp
}
