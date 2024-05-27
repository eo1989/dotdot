local optl = vim.opt_local

vim.cmd([[autocmd! BufEnter <buffer> if winnr('$') < 2 | q | endif]])

optl.scrolloff = 0
optl.wrap = false
optl.number = false
optl.relativenumber = false
optl.linebreak = true
optl.list = true
optl.cursorline = true
optl.spell = false
optl.buflisted = false
optl.signcolumn = 'yes'
