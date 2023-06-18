return {
	    {
		    "Kuchteq/vimoblush",
		    lazy = false, -- make sure we load this during startup if it is your main colorscheme
		    priority = 1000, -- make sure to load this before all the other start plugins
		    config = function()
			    -- TODO BUG the colormode switching does not work if we have used toggleterm in our session before
			    if vim.fn.filereadable("/tmp/theme") == 1 then
				    SYSTHEME = vim.fn.readfile("/tmp/theme")[1]
				    vim.opt.background = SYSTHEME == "dark" and "dark" or "light"
				    if SYSTHEME == "light" then
					    require('everblush').setup({ lightmode = SYSTHEME, false })
				    end
			    end
			    vim.cmd([[colorscheme everblush]])

			    -- function for ~/.local/bin/themeset
			    function themeset(theme)
				    SYSTHEME = theme
				    local booledSystheme = SYSTHEME == "light" and true or false;
				    vim.opt.background = booledSystheme and "light" or "dark"
				    require('everblush').setup({ lightmode = booledSystheme, transparent_background = not booledSystheme })
				    vim.cmd([[colorscheme everblush]])
				    os.execute("colormodeset " .. SYSTHEME)
			    end
		    end,
	    },
	    {
		    "akinsho/bufferline.nvim",
		    event = "VeryLazy",
		    config = function()
			    require("bufferline").setup { options = {
				    always_show_bufferline = false }
			    }
		    end
	    },

	    {
		    "nvim-lualine/lualine.nvim",
		    config = function()
			    require('lualine').setup({ options = { theme = "everblush" } })
		    end
	    },
	    {
		    "phaazon/hop.nvim",
		    branch = 'v2',
		    config = function()
			    require("hop").setup()
			    vim.keymap.set({ 'o', 'n' }, '<c-w>', function()
				    require("hop").hint_words({ current_line_only = true })
			    end, { remap = true })

			    vim.keymap.set({ 'o', 'n' }, '<c-a>', function()
				    require("hop").hint_words({ current_line_only = true, hint_position = require 'hop.hint'.HintPosition.END })
			    end, { remap = true })
		    end
	    },
	    {
		    'L3MON4D3/LuaSnip',
		    keys = { { "<c-p>", mode = "i" } },
		    config = function()
			    require("luasnip.loaders.from_vscode").lazy_load()
		    end,
	    },
	    {
		    'kylechui/nvim-surround',
		    event = "VeryLazy",
		    config = function()
			    require("nvim-surround").setup()
		    end
	    },
	    {
		    'norcalli/nvim-colorizer.lua',
		    event = "VeryLazy",
		    config = function()
			    require("colorizer").setup()
		    end
	    },
	    {
		    'natecraddock/workspaces.nvim',
		    keys = { { "<leader>w" } },
		    config = function()
			    require("workspaces").setup(
				    {
					    hooks = { open = "Telescope find_files",
					    }
				    }
			    )
			    require('telescope').load_extension("workspaces")
			    vim.keymap.set('n', '<leader>w', require("telescope").extensions.workspaces.workspaces, {})
		    end

	    }
    },
    { defaults = { lazy = true } }
