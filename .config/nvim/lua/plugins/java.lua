-- java settins, feel free to get rid of them
return
{
	"mfussenegger/nvim-jdtls",

	dependencies = {
		"nvim-telescope/telescope-dap.nvim",
	},
	ft = "java",
	config = function()
		local config = {
			cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
			root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
			on_attach = function()
				require('jdtls.dap').setup_dap({ hotcodereplace = 'auto' })
				LSP_ON_ATTACH_BASE_SETUP()
			end,
			init_options = {
				bundles = {
					vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
				},
			}
		}
		--require('jdtls').start_or_attach(config)
		require('telescope').load_extension('dap');
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				require('jdtls').start_or_attach(config)
			end,
		})
	end
}
