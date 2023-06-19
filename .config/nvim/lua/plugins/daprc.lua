-- This is shit I know but some day when I have the time I'll make it better
DEBUG_MODE_STATUS = false
DEBUGGABLE_MODE_STATUS = false
DEBUG_MODE_BUFFER_NR = -100
DEBUG_MODE_AUTOCMD_ID = -10

local function toggleEasyDebug()
	-- automatically check if there's a launch.json available and add configuration present there
	require('dap.ext.vscode').load_launchjs(".vscode/launch.json");
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
	local widgets = require('dap.ui.widgets')
	local varsidebar = widgets.sidebar(widgets.scopes, {width=50})
	local palette = require('everblush.palette')
	if DEBUG_MODE_STATUS == false then
		stackmap.pop("debuggable", "n");
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
				{},
				desc = "Toggle Breakpoint"
			},
			{
				"i",
				function()
					vim.api.nvim_feedkeys('j', 'n', false)
					require("dap").toggle_breakpoint()
				end,
				{},
				desc = "Toggle Breakpoint"
			},
			{ "A",     function() require("dap").clear_breakpoints() end, {},                               desc = "Clear all breakpoitns" },
			{ "c",     function() require("dap").continue() end,          { silent = true, nowait = true }, desc = "Continue" },
			{ "o",     function() require("dap").run_to_cursor() end,     {},                               desc = "Run to Cursor" },
			{ "<esc>", debug_mode_toggle,                                 desc = "Escape debug" },
			--{ "dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
			--{ "di", function() require("dap").step_into() end, desc = "Step Into" },
			{ "n",     function() require("dap").down() end,              {},                               desc = "Down" },
			{ "p",     function() require("dap").up() end,                {},                               desc = "Up" },
			{ "r",     function() require("dap").run_last() end,          {},                               desc = "Run Last" },
			{ "q",     function() require("dap").terminate() end,         {},                               desc = "Run Last" },

			--{ "do", function() require("dap").step_out() end, desc = "Step Out" },
			-- D like down, down we go further
			{ "d",     function() require("dap").step_over() end,         { silent = true, nowait = true }, desc = "Step Over" },
			--{ "dp", function() require("dap").pause() end, desc = "Pause" },
			{ "<c-r>", function() require("dap").repl.toggle() end,       { nowait = true },                desc = "Toggle REPL" },
			{"<c-v>",  function() varsidebar.toggle() end,  { nowait = true },		desc = "Toggle Variables"
			},
			--{ "ds", function() require("dap").session() end, desc = "Session" },
			{ "u", function() require("dap").step_back() end,        {},                desc = "Step Back" },
			--{ "a",     function() require("dapui").eval() end,            { , nowait = true },                desc = "Eval" },
			{ "a", function() require("dap.ui.widgets").hover() end, { nowait = true }, desc = "Eval" },
		})
		stackmap.push("with_ui", "v", {
			{ "a", function() require("dapui").eval() end, { nowait = true }, desc = "Eval" },
		})
		lualine.setup({ sections = { lualine_a = { { function() return "DEBUG" end, color = { bg = "#e57474", fg = "#000000" } } } } })
		vim.api.nvim_set_hl(0, 'CursorLine', { ctermbg = 0, fg = palette.color4, bg = '#263252' })
	else
		stackmap.pop("debug_mode", "n")
		stackmap.pop("with_ui", "n")
		stackmap.push("debuggable", "n", { { "q", debug_mode_toggle, desc = "debuggable" } })

		vim.api.nvim_set_hl(0, 'CursorLine', { ctermbg = 10, bg = palette.cursorline })
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
				vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
				vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
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
		{ "theHamsta/nvim-dap-virtual-text" },

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
