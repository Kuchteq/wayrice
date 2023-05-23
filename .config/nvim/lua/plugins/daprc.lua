DEBUG_MODE_STATUS = false
DEBUGGABLE_MODE_STATUS = false
DEBUG_MODE_BUFFER_NR = -100
DEBUG_MODE_AUTOCMD_ID = -10

local function toggleEasyDebug()
	local stackmap = require("stackmap")
	local lualine = require("lualine")
	if DEBUGGABLE_MODE_STATUS == false then
		lualine.setup({ sections = { lualine_b = { { function() return "EASY DEBUG ON" end, color = { fg = "#e57474", gui = "bold" } }, "diagnostics" } } })
		stackmap.push("debuggable", "n", {
			{ "q", debug_mode_toggle, desc = "debuggable" }
		})
	else
		stackmap.pop("debuggable", "n")
		lualine.setup({ sections = { lualine_b = { 'branch', 'diff', 'diagnostics' } } })
	end
	DEBUGGABLE_MODE_STATUS = not DEBUGGABLE_MODE_STATUS
end

-- require'dap.breakpoints'.set({},vim.api.nvim_buf_get_number(0), 22) set stuff programatically
function debug_mode_toggle()
	local stackmap = require("stackmap")
	local lualine = require("lualine")

	if DEBUG_MODE_STATUS == false then
		local bufnr = vim.api.nvim_get_current_buf()
		DEBUG_MODE_BUFFER_NR = bufnr
		stackmap.push("debug_mode", "n", {
			--{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
			{
				"<F2>",
				function()
					require("dap").run(
						{
							-- The first three options are required by nvim-dap
							type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
							request = 'launch',
							name = 'Python: Launch file',
							program = '${file}', -- This configuration will launch the current file if used.
							pythonPath = venv_path and (venv_path .. '/bin/python') or nil,
							noDebug = true
						}, {}
					)
				end,
				{ buffer = bufnr },
				desc = "Toggle Breakpoint"
			},
			{
				"i",
				function()
					vim.api.nvim_feedkeys('j', 'n', false)
					require("dap").toggle_breakpoint()
				end,
				{ buffer = bufnr },
				desc = "Toggle Breakpoint"
			},
			{ "A",     function() require("dap").clear_breakpoints() end, { buffer = bufnr },                               desc = "Clear all breakpoitns" },
			{ "c",     function() require("dap").continue() end,          { buffer = bufnr, silent = true, nowait = true }, desc = "Continue" },
			{ "o",     function() require("dap").run_to_cursor() end,     { buffer = bufnr },                               desc = "Run to Cursor" },
			--{ "dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
			--{ "di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "n",     function() require("dap").down() end,              { buffer = bufnr },                               desc = "Down" },
			{ "p",     function() require("dap").up() end,                { buffer = bufnr },                               desc = "Up" },
			{ "r",     function() require("dap").run_last() end,          { buffer = bufnr },                               desc = "Run Last" },

			--{ "do", function() require("dap").step_out() end, desc = "Step Out" },
			-- D like down, down we go further
			{ "d",     function() require("dap").step_over() end,         { buffer = bufnr, silent = true, nowait = true }, desc = "Step Over" },
			--{ "dp", function() require("dap").pause() end, desc = "Pause" },
			{ "<c-r>", function() require("dap").repl.toggle() end,       { buffer = bufnr, nowait = true },                desc = "Toggle REPL" },
			--{ "ds", function() require("dap").session() end, desc = "Session" },
			--{ "dt", function() require("dap").terminate() end, desc = "Terminate" },
			{ "u",     function() require("dap").step_back() end,         { buffer = bufnr },                               desc = "Step Back" },
			--{ "a",     function() require("dapui").eval() end,            { buffer = bufnr, nowait = true },                desc = "Eval" },
			{ "a",     function() require("dap.ui.widgets").hover() end,            { buffer = bufnr, nowait = true },                desc = "Eval" },
		})
		stackmap.push("with_ui", "v", {
			{ "a", function() require("dapui").eval() end, { buffer = bufnr, nowait = true }, desc = "Eval" },
		})
		DEBUG_MODE_AUTOCMD_ID = vim.api.nvim_create_autocmd({ "BufEnter" }, {
			callback = function()
				local thisbufnr = vim.api.nvim_get_current_buf()
				if thisbufnr == DEBUG_MODE_BUFFER_NR then
					lualine.setup({ sections = { lualine_a = { { function() return "DEBUG" end, color = { bg = "#e57474", fg = "#000000" } } } } })
				else
					lualine.setup({ sections = { lualine_a = { "mode" } } })
				end
			end
		})
		lualine.setup({ sections = { lualine_a = { { function() return "DEBUG" end, color = { bg = "#e57474", fg = "#000000" } } } } })
	else
		stackmap.pop("debug_mode", "n")
		stackmap.pop("with_ui", "n")
		vim.api.nvim_del_autocmd(DEBUG_MODE_AUTOCMD_ID)
		lualine.setup({ sections = { lualine_a = { "mode" } } })
	end
	DEBUG_MODE_STATUS = not DEBUG_MODE_STATUS
end

return {

	"mfussenegger/nvim-dap",
	dependencies = {

		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = "mason.nvim",
			cmd = { "DapInstall", "DapUninstall" },
			config = function()
				local palette = require('everblush.palette')
				vim.api.nvim_create_autocmd({ "FileType" }, {
					pattern = "dap-float",
					callback = function(ev)
						vim.api.nvim_buf_set_keymap(ev.buf, "n", "<esc>", "<cmd>close!<CR>", { silent = true, nowait = true })
					end,
				})
				vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = palette.color1, bg = '#31353f' })
				vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = palette.color4, bg = '#31353f' })
				vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = palette.color2, bg = '#31353f' })
				vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
				vim.fn.sign_define('DapBreakpointCondition', { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
				vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
				vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' })
				vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

				require("nvim-dap-virtual-text").setup()
				require("mason-nvim-dap").setup({
					ensure_installed = { "python" },
					handlers = {}
				})
			end
		},

		{ "Alighorab/stackmap.nvim" },
		{ "theHamsta/nvim-dap-virtual-text"},

		{
			"rcarriga/nvim-dap-ui",
			-- stylua: ignore
			keys = {
				{ "<leader>D", function() require("dapui").toggle({}) end, desc = "Dap UI" },
			},
			config = function(_, opts)
				local dapui = require("dapui")
				dapui.setup({
					layouts = { {
						elements = { {
							id = "scopes",
							size = 0.50
						}, {
							id = "breakpoints",
							size = 0.25
						}, {
							id = "stacks",
							size = 0.25
						}, },
						position = "left",
						size = 40
					}, },
				})
			end,
		}
	},
	-- stylua: ignore
	keys = {
		{ "<leader>d", function()
			--require("dapui").open()
			toggleEasyDebug()
		end } },
}
