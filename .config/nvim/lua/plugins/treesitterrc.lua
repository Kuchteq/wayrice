return {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
                {
                        "nvim-treesitter/nvim-treesitter-textobjects",
                        "nvim-treesitter/nvim-treesitter-context",
                        "windwp/nvim-ts-autotag"
                }
        },
        opts = {
                highlight = { enable = true, additional_vim_regex_highlighting = { "python" } },
                indent = { enable = false },
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
                        "markdown_inline",
                        "python",
                        "go",
                        "regex",
                        "tsx",
                        "typescript",
                        "yaml",
                },

                textobjects = {
                        select = {
                                enable = true,
                                -- problems with dart at least for now
                                disable = { "dart" },

                                -- Automatically jump forward to textobj, similar to targets.vim
                                lookahead = true,

                                keymaps = {
                                        -- You can use the capture groups defined in textobjects.scm
                                        ["af"] = "@function.outer",
                                        ["if"] = "@function.inner",
                                        ["ac"] = "@class.outer",
                                        ["ai"] = "@conditional.outer",
                                        ["ii"] = "@conditional.inner",
                                        -- You can optionally set descriptions to the mappings (used in the desc parameter of
                                        -- nvim_buf_set_keymap) which plugins like which-key display
                                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                                        -- You can also use captures from other query groups like `locals.scm`
                                        ['il'] = "@parameter.inner",
                                        ['al'] = "@parameter.outer",
                                        ['ib'] = "@block.inner",
                                        ['ab'] = "@block.outer"
                                },
                                -- If you set this to `true` (default is `false`) then any textobject is
                                -- extended to include preceding or succeeding whitespace. Succeeding
                                -- whitespace has priority in order to act similarly to eg the built-in
                                -- `ap`.
                                --
                                -- Can also be a function which gets passed a table with the keys
                                -- * query_string: eg '@function.inner'
                                -- * selection_mode: eg 'v'
                                -- and should return true or false
                                include_surrounding_whitespace = false,
                        },
                        move = {
                                enable = true,
                                goto_next_start = {
                                        ['<c-l>'] = "@parameter.inner"
                                },
                                goto_previous_start = {
                                        ['<c-h>'] = "@parameter.inner"
                                }
                        },
                },
                autotag = {
                        enable = true,
                }
        },
        config = function(_, opts)
                require("nvim-treesitter.configs").setup(opts)
        end
}
