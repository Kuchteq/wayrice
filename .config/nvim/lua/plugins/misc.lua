local intty = os.getenv("TERM") == "linux";
return {
        {
            "Kuchteq/vimoblush",
            lazy = false,    -- make sure we load this during startup if it is your main colorscheme
            priority = 1000, -- make sure to load this before all the other start plugins
            config = function()
                if intty then
                    vim.opt.termguicolors = false
                    return
                end
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
                    local booled_systheme = SYSTHEME == "light" and true or false;
                    if booled_systheme then
                        vim.api.nvim_chan_send(2, '\x1b]11;[99]#f7f7f7\a')
                        vim.opt.background = "light"
                    else
                        vim.api.nvim_chan_send(2, '\x1b]11;[85]#000000\a')
                        vim.opt.background = "dark"
                    end
                    require('everblush').setup({ lightmode = booled_systheme, transparent_background = not booled_systheme })
                    vim.cmd([[colorscheme everblush]])
                    os.execute("colormodeset " .. SYSTHEME)
                end
            end,
        },
        {
            'ThePrimeagen/harpoon',
            dependencies = {
                'nvim-lua/plenary.nvim',
            },
            keys = {
                { " ", function()
                    require("harpoon.ui").toggle_quick_menu()
                end },
                { "µ", function()
                    require("harpoon.mark").add_file()
                end },
            },
            event = "VeryLazy",
            config = function()
            end
        },
        {
            "nvim-lualine/lualine.nvim",
            config = function()
                require('lualine').setup({
                    sections = { lualine_c = { { function() if vim.diagnostic.is_disabled() then return " "; else return "" end end, color = { fg = "#005577", gui = "bold" } }, "filename" } },
                    options = {
                        section_separators = { left = '', right = '' },
                        theme = "everblush"
                    }
                })
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
                if not intty then
                    require("colorizer").setup()
                end
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

        },
        {
            'numToStr/Comment.nvim',
            event = "VeryLazy",
            config = function()
                require("Comment").setup()
            end
        },
    },
    { defaults = { lazy = true } }
