local bo, cmd, fn, fmt, map, wo = vim.bo, vim.cmd, vim.fn, string.format, vim.keymap.set, vim.wo

local options = {
  tabstop = 8,
  textwidth = 100,
  shiftwidth = 4,
  softtabstop = 4,
  autoindent = true,
  expandtab = true,
}
local window_local_only = {
  colorcolumn = '+1',
  conceallevel = 2,
}

for k, v in pairs(options) do
  bo[k] = v
end

for k, v in pairs(window_local_only) do
  wo[k] = v
end
