vim.keymap.set("n", "þ", ":set titlestring=vilf<CR><cmd>lua _lf_toggle()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "ó", ":set titlestring=vilf<CR><cmd>lua _lf_toggle_here()<CR>", { silent = true, noremap = true })

return {
	'akinsho/toggleterm.nvim',
	version = "*",
	event = "VeryLazy",
	config = function()
		local lfStart = "lf"
		-- If there is the server variable (received by launching with vimd)
		NVIM_SERVER_ON=vim.api.nvim_get_vvar("servername")
		if NVIM_SERVER_ON then
			lfStart = "NVSERVER=" .. NVIM_SERVER_ON .. " lf -command invim"
		end
		local whereOpen = ""
		local firstTime = true

		local function moveToWhereOpen()
			if whereOpen ~= "" and firstTime == false then
				-- LF_CLIENT_ID received by lf -command invim callback
				vim.fn.jobstart("lf -remote 'send " .. LF_CLIENT_ID .. " select \"" .. whereOpen .. "\"'")
				whereOpen = ""
			end
		end
		local Terminal = require('toggleterm.terminal').Terminal
		local lf = Terminal:new({
			cmd = lfStart,
			dir = whereOpen,
			direction = "float",
			float_opts = {
				border = "rounded",
			},
			highlights = {
				FloatBorder = { guifg = require('everblush.palette').color4 }
			},
			-- function to run on opening the terminal
			on_open = function(term)
				moveToWhereOpen()
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "þ",
					"<cmd>lua _lf_toggle()<CR>:set titlestring=<CR>", { noremap = true, silent = true })
				firstTime = false
			end,
		})
		function _lf_toggle()
			lf:toggle()
		end

		function _lf_toggle_here()
			whereOpen = vim.api.nvim_buf_get_name(0)
			lf:toggle()
		end
	end
}
