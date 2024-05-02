local intty = os.getenv("TERM") == "linux";
local themepath = os.getenv("XDG_RUNTIME_DIR") .. "/theme";
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
                        if vim.fn.filereadable(themepath) == 1 then
                                SYSTHEME = vim.fn.readfile(themepath)[1]
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
                commit = 'e76cb03',
                branch = "harpoon2",
                keys = {
                        { " ", function()
                                require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
                        end },
                        { "µ", function()
                                require("harpoon"):list():add()
                        end },
                },
                event = "VeryLazy",
                config = function()
                        local harpoon = require("harpoon")
                        harpoon:setup({
                                settings = {
                                        save_on_toggle = true,
                                        sync_on_ui_close = true,
                                        key = function()
                                                return vim.loop.cwd()
                                        end,
                                },
                        })
                end,
                lazy = false
        },
        {
                "nvim-lualine/lualine.nvim",
                config = function()
                        require('lualine').setup({
                                sections = { lualine_c = { { function() if vim.diagnostic.is_disabled() then return " "; else return "" end end, color = { fg = "#005577", gui = "bold" } }, "filename", { "aerial" } } },
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
        {
                'stevearc/aerial.nvim',
                opts = { nerd_font = true },
                keys = { { "π", function()
                        require("aerial").toggle();
                end } },
        },
        {
                'windwp/nvim-autopairs',
                event = "InsertEnter",
                opts = {}
        },
        {
                "Kuchteq/build.nvim",
                keys = { {
                        "<F2>",
                        mode = { "n", "i" },
                        function()
                                require('build').run_make()
                        end
                } },
                dependencies = {
                        'm00qek/baleia.nvim',
                },
                config = function()
                        require("build").setup();
                end
        },
        {
                "boltlessengineer/smart-tab.nvim",
                config = function()
                        require('smart-tab').setup({
                                -- default options:
                                -- list of tree-sitter node types to filter
                                skips = { "string_content" },
                                -- default mapping, set `false` if you don't want automatic mapping
                                mapping = "<tab>",
                                -- filetypes to exclude
                                exclude_filetypes = {}
                        })
                end
        }


}, { defaults = { lazy = true } }
