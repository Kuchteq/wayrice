vim.opt.fillchars = { eob = " " }
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.shortmess:append({ I = true })
vim.o.showcmd = false
vim.o.showmode = false
vim.o.laststatus = 1
vim.o.clipboard = "unnamedplus"
vim.o.cmdheight = 0

vim.o.background=nil -- Set it for transparency
vim.api.nvim_set_hl(0, "StatusLine", {bg = nil, fg = nil, sp = nil})
vim.api.nvim_set_hl(0, "Normal", {bg = nil})


function themeset(theme)
        SYSTHEME = theme
        local booled_systheme = SYSTHEME == "light" and true or false;
        if booled_systheme then
                vim.o.background = "light"
                vim.api.nvim_set_hl(0, "Normal", {fg = "#000000"})
        else
                vim.o.background = "dark"
                vim.api.nvim_set_hl(0, "Normal", {fg = "#dadada"})
        end
        os.execute("colormodeset " .. SYSTHEME)
end
