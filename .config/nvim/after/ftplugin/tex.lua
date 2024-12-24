vim.keymap.set('n', '<F2>', ':VimtexCompile<CR>', { noremap = true, silent = true, buffer = true })
vim.keymap.set('n', '<c-f>', ':VimtexView<CR>', { noremap = true, silent = true, buffer = true })
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*.tex",
  callback = function()
    local source_file = "/tmp/vimtex_build/" .. vim.fn.expand("%:t:r") .. ".pdf"

    -- Use Vim's `jobstart` to run the `mv` command
    vim.fn.jobstart({ "mv", source_file, vim.fn.getcwd() }, {
      on_exit = function(_, exit_code)
        if exit_code == 0 then
          print("Moved " )
        else
          print("Failed to move " .. source_file)
        end
      end,
    })
  end,
})
