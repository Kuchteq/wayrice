return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	-- dependencies = {
	-- 	{
	-- 		"nvim-treesitter/nvim-treesitter-textobjects",
	-- 	}
	-- },
	opts = {
		highlight = { enable = true },
		--indent = { enable = true },
		context_commentstring = { enable = true, enable_autocmd = false },
		ensure_installed = {
			"bash",
			"c",
			"dart",
			"html",
			"javascript",
			"json",
			"java",
			"lua",
			"luap",
			"markdown",
			"markdown_inline",
			"python",
			"go",
			"regex",
			"tsx",
			"typescript",
			"yaml",
		}
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end
}
