vim.opt.fillchars = { eob = " " }
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.shortmess:append({ I = true })
vim.o.noshowcmd = 1
vim.o.noshowmode = 1
vim.o.laststatus = 1
vim.o.clipboard = "unnamedplus"

--config = vim.tbl_deep_extend('force', config, opts)
vim.api.nvim_set_hl(0, "StatusLine", {bg = nil, fg = nil, sp = nil})
