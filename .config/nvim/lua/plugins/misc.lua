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
                                        vim.opt.background = "light"
                                        vim.api.nvim_chan_send(2, '\x1b]11;[96]#ffffff\a') -- these are needed because when we toggle
                                        -- lf term or any terminal emulator inside vim for that matter, things start looking badly
                                else
                                        vim.opt.background = "dark"
                                        vim.api.nvim_chan_send(2, '\x1b]11;[85]#000000\a')
                                end
                                require('everblush').setup({ lightmode = booled_systheme, transparent_background = true })
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
                branch = "harpoon2",
                keys = {
                        { "␣", function()
                                require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
                        end },
                        { "µ", function()
                                require("harpoon"):list():add()
                        end },
                        { "≠", function() require("harpoon"):list():select(1) end, { silent = true } },
                        { "²", function() require("harpoon"):list():select(2) end, { silent = true } },
                        { "³", function() require("harpoon"):list():select(3) end, { silent = true } },
                        { "¢", function() require("harpoon"):list():select(4) end, { silent = true } }
                },
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
        },
        {
                "nvim-lualine/lualine.nvim",
                event = "VeryLazy",
                config = function()
                        require('lualine').setup({
                                sections = { lualine_c = { { function() if vim.diagnostic.is_enabled() then return ""; else return " " end end, color = { fg = "#005577", gui = "bold" } }, "filename", { "aerial" } } },
                                options = {
                                        section_separators = { left = '', right = '' },
                                        theme = "everblush"
                                }
                        })
                end
        },
        {
                "smoka7/hop.nvim",
                keys = { {
                        "<c-w>",
                        mode = { "n", "o" },
                        remap = true,
                        nowait = true,
                        function()
                                require("hop").hint_words({ current_line_only = true })
                        end
                } },
                config = function()
                        require("hop").setup()
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
                event = "VeryLazy",
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
                lazy=false,
                keys = { {
                        "<F2>",
                        mode = { "n", "i" },
                        function()
                                require('build').run_make()
                                vim.lsp.buf.format { async = true }
                        end
                } },
                config = function()
                        require("build").setup();
                end
        },
        {
                "lervag/vimtex",
                lazy = false, -- we don't want to lazy load VimTeX
                -- tag = "v2.15", -- uncomment to pin to a specific release
                init = function()
                        vim.g.vimtex_view_method = "zathura"
                        vim.g.vimtex_compiler_latexmk = {
                                aux_dir = "/tmp/vimtex_build",
                                out_dir = "/tmp/vimtex_build"
                        }
                end
        },
        {
            'MagicDuck/grug-far.nvim',
            config = function()
              require('grug-far').setup({ });
            end
          },
}
