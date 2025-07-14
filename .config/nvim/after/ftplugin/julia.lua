local optl = vim.opt_local
local bo = vim.bo
-- local b = vim.b

bo.tabstop = 4
bo.textwidth = 79
bo.shiftwidth = 4
bo.softtabstop = 4
bo.expandtab = true
bo.autoindent = true
optl.smarttab = true
optl.colorcolumn = '+1'

-- bo.keywordprg = nil

-- vim.cmd([[
-- " TSBufToggle highlight
-- " setl keywordprg=
-- ]])
