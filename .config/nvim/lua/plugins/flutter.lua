return {
	'akinsho/flutter-tools.nvim',
	lazy = false,
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function()
		require("flutter-tools").setup {
			debugger = {
				enabled = true,
				exception_breakpoints = {},
				register_configurations = function(paths)
					require("dap").configurations.dart = {
						{
							type = "dart",
							request = "launch",
							name = "Launch flutter",
							dartSdkPath = paths.dart_sdk,
							flutterSdkPath = paths.flutter_sdk,
							program = "${workspaceFolder}/main.dart",
							cwd = "${workspaceFolder}",
						}
					}
				end,
			},
			lsp = {
				on_attach = LSP_ON_ATTACH_BASE_SETUP,
				settings = {
					lineLength = 90
				}
			}
		}
	end

}
