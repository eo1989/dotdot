---@type vim.lsp.Config
return {
  cmd = {
    'jetls',
    '--threads=auto',
    '--',
  },
  filetypes = { 'julia' },
}
