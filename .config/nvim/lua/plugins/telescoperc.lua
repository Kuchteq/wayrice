-- function called by lf on pressing c-g, making vim a nice live grepper with an easy way out
function startInTelescopeOnly()
	vim.keymap.set("n", "<C-c>", ":qa!")
	vim.keymap.set("i", "<C-c>", ":qa!")
	require('telescope.builtin').live_grep({
		layout_strategy = 'current_buffer',
		attach_mappings = function(_, map)
			map({ "i", "n" }, "<C-c>", { "<cmd>:qa!<CR>", type = "command" })
			return true
		end
	});
end

return {
	'nvim-telescope/telescope.nvim',
	dependencies = { 'nvim-lua/plenary.nvim' },
	keys = { 'æ', 'ŋ', '’', 'gr', 'gd' },
	config = function()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', 'æ', builtin.find_files, {})
		vim.keymap.set('n', 'ŋ', builtin.live_grep, {})
		vim.keymap.set('n', '’', builtin.resume, {})
		vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
		vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
                vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, {})
		require('telescope').setup {
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
						["<C-p>"] = "cycle_history_prev",
						["<C-n>"] = "cycle_history_next",
						["ŋ"] = "close",
						["æ"] = "close"
					}
				}
			} }
	end
}
