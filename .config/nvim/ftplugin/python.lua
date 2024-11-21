vim.b.slime_cell_delimiter = '#\\s\\=%%'
-- vim.b.slime_cell_delimiter = [[# %%]]
-- tabstop = 4,
-- textwidth = 79,
-- shiftwidth = 4,
-- expandtab = true,
-- smarttab = true,
-- conceallevel = 2,
-- colorcolumn = '+1',
-- foldmethod = 'indent'

-- vim.bo.textwidth = 79
-- vim.b.textwidth = 79
-- vim.opt_local.ts = 4 -- 8?
-- vim.opt_local.sw = 4
-- vim.opt_local.sts = 4
-- vim.opt_local.et = true
-- vim.opt_local.ai = true
-- vim.opt_local.sta = true
-- vim.opt_local.cc = '+1'
-- vim.opt_global.fdm = 'syntax' -- indent?
-- vim.opt_local.fdm = 'indent' -- syntax?

-- vim.cmd([[call matchadd('TabLineSel', '\%80v', 79)]])

vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'

-- dont automatically adjust indentation when typing ":"
-- need to do this in an autocmd. see https://stackoverflow.com/a/37889460/4151392
vim.opt_local.indentkeys:remove { '<:>' }
vim.opt_local.indentkeys:append { '=else:' }
