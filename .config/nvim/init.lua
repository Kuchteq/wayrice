api = vim.api
-- general settings
vim.o.title = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.so = 3
vim.o.cmdheight = 0
vim.opt.showmode = false
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.clipboard = "unnamedplus"
-- no case sensitive searches by default but if I type something in uppercase then turn it on
vim.o.smartcase = true
vim.o.ignorecase = true
-- using lf as file viewer so no need to load netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- tab options
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
-- NOTE TO FUTURE SELF, some asshole might set .editorconfig file which overwrites these settings, bear this in mind!
-- Modify the indentation levels there if they are overwrittien.

local sync_dir_with_shell = function()
    vim.api.nvim_chan_send(2, '\x1b]7;file://' .. vim.fn.hostname() .. vim.fn.getcwd())
end

vim.api.nvim_create_autocmd({ "DirChanged" }, {
    callback = sync_dir_with_shell
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        -- if we are editing a shell file we don't want to sync directory with /tmp shell
        if vim.fn.expand("%:p:h") == "/tmp" and vim.bo.filetype == "zsh" then
            vim.keymap.set("n", "<enter>", ":wq<CR>", { buffer = true })
            vim.o.titlestring = "Shell at: " .. vim.fn.getcwd();
            vim.bo.filetype = "bash"
        else
            vim.api.nvim_command("cd %:p:h")
            sync_dir_with_shell()
        end
    end
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "/tmp/calcurse*,~/.calcurse/notes/*",
    callback = function()
        vim.bo.filetype = "markdown"
    end
})

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
vim.keymap.set("n", "≠", function() require("harpoon.ui").nav_file(1) end, { silent = true })
vim.keymap.set("n", "²", function() require("harpoon.ui").nav_file(2) end, { silent = true })
vim.keymap.set("n", "³", function() require("harpoon.ui").nav_file(3) end, { silent = true })
vim.keymap.set("n", "¢", function() require("harpoon.ui").nav_file(4) end, { silent = true })
vim.keymap.set("n", "|", ":vsplit<CR>")
vim.keymap.set("n", "–", ":split<CR>")
vim.keymap.set("n", "©", ":%s//g<Left><Left>")
vim.keymap.set("n", "<C-s>", ":silent update<CR>", { silent = true })
vim.keymap.set("n", "<leader>fd", ":filetype detect<CR>")
vim.keymap.set("i", "<C-k>", "<esc>ldei")
-- custom replace functions for visual mode
vim.keymap.set('v', '©', '"hy:%s/<C-r>h//gc<left><left><left>', { noremap = true })

-- split navigation using right alt + wsad, control activated using right alt + e
vim.keymap.set("n", "ę", "<C-w>")
vim.keymap.set("n", "ä", "<C-w>h")
vim.keymap.set("n", "ß", "<C-w>j")
vim.keymap.set("n", "œ", "<C-w>k")
vim.keymap.set("n", "ś", "<C-w>l")
vim.keymap.set("n", "Ś", ":vertical resize +5<CR>", {silent=true})
vim.keymap.set("n", "Ä", ":vertical resize -5<CR>", {silent=true})
-- Document related mappings
-- Compile the files for fast preview, in groff's case, they won't have images tho
vim.keymap.set("n", "<leader>c", ":w<CR>:!compiler '%:p'<CR><CR>")
-- Compile the files for final, for groff there will be images and smaller size
vim.keymap.set("n", "<leader>C", ":!compiler '%:p' -F<CR>")
vim.keymap.set("n", "<leader>m", ":!make<CR>")
vim.keymap.set("n", "<leader>p", ":!opout '%:p'<CR>")

-- Save file as sudo on files that require root permission with the command w!!
vim.cmd("cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!")
-- Plain run and output the result
vim.keymap.set("n", "<F2>", function()
    require("dap").continue();
end)

-- set up undodir
local cachePrefix = vim.env.XDG_CACHE_HOME
vim.opt.undodir = { cachePrefix .. "/nvim/.undodir" }
vim.opt.undofile = true

-- setting up plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath, }) end
vim.opt.rtp:prepend(lazypath)
-- this line causes lazy nvim plugin manager to execute and load stuff from the plugins folder
require("lazy").setup("plugins")

require("shortcuts")
