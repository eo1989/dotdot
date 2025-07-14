if not eo then return end

local optl = vim.opt_local

-- TODO: this is set in the autocommk file ... do i leave this or leave the autocomm vim.cmd?
vim.cmd([[autocmd! BufEnter <buffer> if winnr('$') < 2 | q | endif]])

-- vim.api.nvim_exec_autocmds({ 'Filetype', 'BufEnter', 'BufWinEnter' }, {
--   group = 'treesitter_stuff',
--   -- pattern = '*',
--   buffer = 0,
--   callback = function()
--     pcall(vim.treesitter.start)
--     -- vim.bo[args.buf].syntax = 'ON'
--   end,
-- })

-- vim.bo['ft'].syntax = 'on'
-- if vim.version().minor >= 12 then
--   vim.treesitter.start(0, require('nvim-treesitter').supported_filetypes())
-- else
--   vim.bo.syntax = 'ON'
--   return true
-- end

optl.scrolloff = 0
optl.wrap = false
optl.number = false
-- optl.relativenumber = false
-- optl.linebreak = true
-- optl.list = true
optl.cursorline = true
optl.spell = false
optl.buflisted = false
optl.signcolumn = 'yes'

map('n', 'dd', eo.list.qf.delete, { desc = 'delete current qf entry', buffer = 0 })
map('v', 'd', eo.list.qf.delete, { desc = 'delete current qf entry', buffer = 0 })
map('n', 'H', ':colder<CR>', { buffer = 0 })
map('n', 'L', ':cnewer<CR>', { buffer = 0 })

-- force qf to open beneath all other splits
vim.cmd.wincmd('J')
eo.adjust_split_height(3, 10)
