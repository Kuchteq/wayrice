return {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        settings = {
                Lua = {
                        workspace = {
                                library = vim.api.nvim_get_runtime_file("", true)
                        }
                }
        },
        root_markers = { 'init.lua', '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git', }
}
