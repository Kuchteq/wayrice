-- if anyone wants to use smooth scrolling then it's here
return {
	"karb94/neoscroll.nvim",
	event = "VeryLazy",
	config = function()
		local t = {}
		t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '150' } }
		t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '150' } }
		require('neoscroll').setup()
		require('neoscroll.config').set_mappings(t)
	end
}
