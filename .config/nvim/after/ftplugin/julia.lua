local optl = vim.opt_local
-- local bo = vim.bo

-- vim.g.slime_cell_delimiter = '#\\s\\=%%'
vim.b['slime_cell_delimiter'] = '#\\s\\=%%'
vim.b['slime_bracketed_paste'] = true

-- vim.treesitter.start()

vim.g.navic_silence = true

-- bo.tabstop = 4
-- bo.textwidth = 79
-- bo.shiftwidth = 4
-- bo.softtabstop = 4
-- bo.expandtab = true
-- bo.autoindent = true
-- optl.smarttab = true

optl.colorcolumn = '+1'

local options = {
  tabstop = 8,
  textwidth = 91, -- virt-column should show at 92 where most linters/formatters are set
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
  smarttab = true,
  colorcolumn = '+1',
}

for k, v in pairs(options) do
  vim.o[k] = v
end

-- bo.keywordprg = nil

-- vim.cmd([[
-- " TSBufToggle highlight
-- " setl keywordprg=
-- ]])
