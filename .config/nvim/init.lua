-- general settings
vim.o.title = 1
vim.o.number = true
vim.o.relativenumber = true
vim.o.so = 3
vim.o.cmdheight = 0
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"
-- vim.opt.autochdir = true, the bottom one is similar but it is ran only on once on enter, 
-- this makes it so that telescope or anything that depends on PWD still search stuff
vim.api.nvim_create_autocmd({ "VimEnter" }, { command = "cd %:p:h" })
-- no case sensitive searches by default but if I type something in uppercase then turn it on
vim.o.smartcase = true
vim.o.ignorecase = true
-- using lf as file viewer so no need to load netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- tab options
vim.opt.tabstop = 6
vim.opt.shiftwidth = 6
vim.opt.softtabstop = 6
vim.opt.cindent = true

-- disable greeting screen
vim.opt.shortmess:append({ I = true })
-- disable tilde characters on the left ~ 
vim.opt.fillchars = { eob = " " }

vim.g.mapleader = ' '
-- keymaps contain special characters produced by modified xkb_symbols files
-- these characters are produced on holding AltGr (right alt) + something
vim.keymap.set("n", "<C-q>", ":bd<CR>", { silent = true })
vim.keymap.set("n", "ə", ":bn<CR>", { silent = true })
vim.keymap.set("n", "…", ":bp<CR>", { silent = true })
vim.keymap.set("n", "ć", ":only<CR>", { silent = true })
vim.keymap.set("n", "≠", ":BufferLineGoToBuffer1<CR>", { silent = true })
vim.keymap.set("n", "²", ":BufferLineGoToBuffer2<CR>", { silent = true })
vim.keymap.set("n", "³", ":BufferLineGoToBuffer3<CR>", { silent = true })
vim.keymap.set("n", "¢", ":BufferLineGoToBuffer4<CR>", { silent = true })
vim.keymap.set("n", "ρ", ":vsplit<CR>")
vim.keymap.set("n", "–", ":split<CR>")
vim.keymap.set("n", "©", ":%s//g<Left><Left>")
vim.keymap.set("n", "<C-s>", ":w!<CR>")
vim.keymap.set("n", "<leader>fd", ":filetype detect<CR>")
vim.keymap.set("i", "<C-e>", "<esc>ldei")
-- custom replace functions for visual mode
vim.keymap.set('v', '©', '"hy:%s/<C-r>h//gc<left><left><left>', { noremap = true })

-- split navigation using right alt + wsad, control activated using right alt + e
vim.keymap.set("n", "ę", "<C-w>")
vim.keymap.set("n", "ä", "<C-w>h")
vim.keymap.set("n", "ß", "<C-w>j")
vim.keymap.set("n", "œ", "<C-w>k")
vim.keymap.set("n", "ð", "<C-w>l")
-- start up a new terminal window straight away in the same path
vim.keymap.set('n', '<leader>t', ":!setsid -f $TERMINAL >/dev/null 2>&1<CR><ESC>")

-- Document related mappings
-- Compile the files for fast preview, in groff's case, they won't have images tho
vim.keymap.set("n", "<leader>c", ":w<CR>:!compiler '%:p'<CR><CR>")
-- Compile the files for final, for groff there will be images and smaller size
vim.keymap.set("n", "<leader>C", ":!compiler '%:p' -F<CR>")
vim.keymap.set("n", "<leader>p", ":!opout '%:p'<CR>")

-- Save file as sudo on files that require root permission with the command w!!
vim.cmd("cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")

-- set up undodir
local cachePrefix = vim.env.XDG_CACHE_HOME
vim.opt.undodir = { cachePrefix .. "/nvim/.undodir" }
vim.opt.undofile = true

-- setting up plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then vim.fn.system({"git","clone","--filter=blob:none","https://github.com/folke/lazy.nvim.git","--branch=stable",lazypath,}) end
vim.opt.rtp:prepend(lazypath)
-- this line causes lazy nvim plugin manager to execute and load stuff from the plugins folder
require("lazy").setup("plugins")

require("shortcuts")
