---@type vim.lsp.Config
return {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown', 'markdown.mdx', 'quarto' },
  root_markers = {
    { '.marksman.toml' },
    '.git',
  },
  single_file_support = true,
  on_attach = function(client, _)
    -- if client.server_capabilities then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentOnTypeFormattingProvider = false
    client.server_capabilities.documentHighlightProvider = false
    -- end
  end,
}
