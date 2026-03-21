---@type vim.lsp.Config
return {
  cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
  filetypes = { 'sql', 'mysql' },
  ---@param client vim.lsp.Client
  root_markers = { '.sqllsrc.json' },
  single_file_support = true,
  settings = {},
}
