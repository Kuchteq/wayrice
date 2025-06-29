-- TODO, offload this to the plugin itself
function _G.TabLine()
        local tags = require("grapple").tags()
        if not tags then return "" end

        local current_buf_path = vim.fn.expand("%:p")

        local display_tags = vim
            .iter(tags)
            :enumerate()
            :map(function(i, tag)
                    local redacted_path = vim.fn.fnamemodify(tag.path, ":t")
                    local display = i .. " ~ " .. redacted_path
                    if tag.path == current_buf_path then
                            -- This is scuffed as hell but eeh
                            return "%#TabLine#" .. display .. "%#TabLineReset#"
                    end
                    return display
            end)
            :totable()

        return table.concat(display_tags, " | ")
end

local function grapple_tabline()
        local tags = require("grapple").tags()
        if #tags > 0 then vim.o.showtabline = 2 else vim.o.showtabline = 0 end
end

function startInTelescopeOnly()
        vim.keymap.set("n", "<C-c>", ":qa!")
        vim.keymap.set("i", "<C-c>", ":qa!")
        require('telescope.builtin').live_grep({
                layout_strategy = 'current_buffer',
                attach_mappings = function(_, map)
                        map({ "i", "n" }, "<C-c>", { "<cmd>:qa!<CR>", type = "command" })
                        return true
                end
        });
end

return {
        {
                "cbochs/grapple.nvim",
                event = {"BufReadPost", "VeryLazy"},
                config = function()
                        require("grapple").setup({
                                scope = "git",
                                icons = false,
                                win_opts = {
                                        footer = ""
                                }

                        })
                        vim.o.tabline = '%!v:lua.TabLine()'
                        grapple_tabline()
                end,
                keys = {
                        { "µ", function()
                                require("grapple").toggle(); grapple_tabline()
                        end, { silent = true } },
                        { "␣", function() require("grapple").toggle_tags() end },
                        { "≠", function() require("grapple").select({ index = 1 }) end },
                        { "²", function() require("grapple").select({ index = 2 }) end },
                        { "³", function() require("grapple").select({ index = 3 }) end },
                        { "¢", function() require("grapple").select({ index = 4 }) end },
                        { "€", function() require("grapple").select({ index = 5 }) end },
                },
        },
        {
                'nvim-telescope/telescope.nvim',
                dependencies = { 'nvim-lua/plenary.nvim' },
                keys = { 'ž', 'č', '’', 'gr', 'gd' },
                config = function()
                        local builtin = require('telescope.builtin')
                        vim.keymap.set('n', 'ž', builtin.find_files, {})
                        vim.keymap.set('n', 'č', builtin.live_grep, {})
                        vim.keymap.set('n', '’', builtin.resume, {})
                        vim.keymap.set('n', '→', builtin.buffers, {})
                        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
                        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
                        vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, {})
                        vim.keymap.set('n', 'ł', require('telescope.builtin').lsp_dynamic_workspace_symbols, {})
                        require('telescope').setup {
                                defaults = {
                                        mappings = {
                                                i = {
                                                        ["<C-j>"] = "move_selection_next",
                                                        ["<C-k>"] = "move_selection_previous",
                                                        ["<C-p>"] = "cycle_history_prev",
                                                        ["<C-n>"] = "cycle_history_next",
                                                        ["ž"] = "close",
                                                        ["č"] = "close"
                                                }
                                        }
                                } }
                end
        }
}
