-- java settins, feel free to get rid of them
return
{
	"mfussenegger/nvim-jdtls",

	dependencies = {
		"nvim-telescope/telescope-dap.nvim",
	},
	ft = "java",
	config = function()
		-- Preparing required paths
		local mason_registry = require("mason-registry")
		local jdtls_pkg = mason_registry.get_package("jdtls")
		local jdtls_path = jdtls_pkg:get_install_path()
		local jdtls_bin = jdtls_path .. "/bin/jdtls"

		local java_test_pkg = mason_registry.get_package("java-test")
		local java_test_path = java_test_pkg:get_install_path()

		local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
		local java_dbg_path = java_dbg_pkg:get_install_path()

		local jar_patterns = {
			java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
			java_test_path .. "/extension/server/*.jar",
		}

		local bundles = {}
		for _, jar_pattern in ipairs(jar_patterns) do
			for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
				table.insert(bundles, bundle)
			end
		end
		local config = {
			cmd = { jdtls_bin },
			root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
			on_attach = function()
				vim.keymap.set("n", "<F3>", function()
					require("jdtls").test_class();
				end, { silent = true, buffer = true })
				vim.keymap.set("n", "<F4>", function()
					require("jdtls").pick_test();
				end, { buffer = true })

				require('jdtls.dap').setup_dap({ hotcodereplace = 'auto', config_overrides = { console = "internalConsole" } })
				require('jdtls.setup').add_commands();
				LSP_ON_ATTACH_BASE_SETUP()
			end,
			init_options = {
				bundles = bundles }
		}

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				require('jdtls').start_or_attach(config)
			end,
		})
	end
}
