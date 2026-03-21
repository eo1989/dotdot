---@type vim.lsp.Config
return {
  cmd = { 'postgres-language-server', 'lsp-proxy' },
  filetypes = { 'sql' },
  ---@param client vim.lsp.Client
  single_file_support = true,
  root_markers = { 'postgres-language-server.jsonc' },
  workspace_required = true,
  settings = {},
}
