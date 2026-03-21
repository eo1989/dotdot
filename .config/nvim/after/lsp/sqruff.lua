---@type vim.lsp.Config
return {
  ---@param client vim.lsp.Client
  cmd = { 'sqruff', 'lsp' },
  filetypes = { 'sql' },
  root_markers = { '.sqruff', { '.git' } },
  single_file_support = true,
  -- exit_timeout = true,
  -- on_attach = function(client) client.server_capabilities.documentHighlightProvider = false end,
}
