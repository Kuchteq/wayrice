return {
        { 'RaafatTurki/hex.nvim',
        keys = { { "<leader>h", function ()
                require 'hex'.toggle();
                vim.o.binary =  not vim.o.binary
                vim.o.binary =  not vim.o.endofline
        end }},
        config = function ()
                require 'hex'.setup()
        end}
}
