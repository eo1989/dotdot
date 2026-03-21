-- DOCS https://github.com/rvben/rumdl/blob/main/docs/lsp.md
--------------------------------------------------------------------------------

---@type vim.lsp.Config
return {
  ---@param client vim.lsp.Client
  cmd = { 'rumdl', 'server' },
  filetypes = { 'markdown', 'quarto' },
  root_markers = { '.git' },
  single_file_support = true,
  exit_timeout = true,
  on_attach = function(client, _)
    client.server_capabilities.documentHighlightProvider = false
  end,
  settings = {
    rumdl = {
      -- less noisy, since info diagnostics are configured to not get virtual text
      MD009 = { severity = "info" }, -- traiing commas
      MD012 = { severity = "info" }, -- multiple blank lines
      MD060 = { severity = "info" }, -- table columns
    }
  },
}
