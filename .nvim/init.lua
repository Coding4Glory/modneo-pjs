vim.cmd('source .nvim/genhelp.lua')

vim.keymap.set('n', '<localleader>t', '<Cmd>PlenaryBustedDirectory tests<CR>', { desc = "run [t]ests" })
