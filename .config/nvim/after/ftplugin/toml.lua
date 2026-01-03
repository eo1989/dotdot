local bo, optl = vim.bo, vim.opt_local

-- bo.ts = 8
-- bo.sw = 4
-- bo.sts = -1
-- bo.et = true
-- bo.ai = false
optl.colorcolumn = '+1'

local options = {
  tabstop = 8,
  textwidth = 79,
  shiftwidth = 2,
  softtabstop = -1,
  expandtab = true,
}

for k, v in pairs(options) do
  vim.o[k] = v
end
