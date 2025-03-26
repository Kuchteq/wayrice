local autocmd_id = -1
vim.bo.makeprg = "typst compile %"
vim.cmd(":onoremap <silent> i$ :<c-u>normal! T$vt$<cr>")
vim.cmd(":onoremap <silent> a$ :<c-u>normal! F$vf$<cr>")
vim.cmd(":vnoremap i$ T$ot$<cr>")
vim.cmd(":vnoremap a$ T$ot$<cr>")

vim.keymap.set('n', '<F2>', function()
        if autocmd_id ~= -1 then
                vim.api.nvim_del_autocmd(autocmd_id)
                autocmd_id = -1
                vim.fn.jobstart({ "sb-notifier", "-m", " stopped " })
        else
                autocmd_id = vim.api.nvim_create_autocmd("BufWritePost", {
                        pattern = "*.typ",
                        command = "silent make"
                })
                vim.fn.jobstart({ "sb-notifier", "-m", " started " })
                vim.fn.jobstart({ "pgrep", "-f", "zathura " .. vim.fn.expand("%:p:r") .. ".pdf" }, {
                        on_exit = function(_, code, _)
                                if code ~= 0 then
                                        vim.fn.jobstart({ "zathura", vim.fn.expand("%:p:r") .. ".pdf" })
                                end
                        end
                })
                vim.cmd("write")
        end
end, { noremap = true, silent = true, buffer = true })
