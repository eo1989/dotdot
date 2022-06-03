-- Overide lspconfigs default border (or lack thereof)
vim.api.nvim_win_set_config(0, {border = as.style.current.border })
-- vim.opt_local.winhighlight = table.concat({
--   'NormalFloat:GreyFloat',
--   'EndOfBuffer:GreyFloat',
--   'FloatBorder:GreyFloatBorder',
-- }, ',')
