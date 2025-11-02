local optl = vim.opt_local
-- local bo = vim.bo

vim.b.slime_cell_delimiter = '#\\s\\=%%'

-- bo.tabstop = 4
-- bo.textwidth = 79
-- bo.shiftwidth = 4
-- bo.softtabstop = 4
-- bo.expandtab = true
-- bo.autoindent = true
optl.smarttab = true
optl.colorcolumn = '+1'

local options = {
  tabstop = 4,
  textwidth = 92,
  shiftwidth = 4,
  softtabstop = 4,
  expandtab = true,
  smarttab = true,
}

for k, v in pairs(options) do
  vim.o[k] = v
end

-- bo.keywordprg = nil

-- vim.cmd([[
-- " TSBufToggle highlight
-- " setl keywordprg=
-- ]])
