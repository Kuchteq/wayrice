return {
    'akinsho/flutter-tools.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    ft = "dart",
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
                on_attach = function(client,_) client.server_capabilities.semanticTokensProvider = nil; end,
                settings = {
                    lineLength = 90
                }
            }
        }
    end

}
