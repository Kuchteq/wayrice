return {
        cmd = { 'clangd', '--background-index' },
        filetypes = { 'c', 'cpp' },
        root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
}
