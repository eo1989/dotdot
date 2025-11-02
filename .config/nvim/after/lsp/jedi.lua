--[[
Testing jedi for the hover feature, between this and pylsp or pyright as theyre the most mature and fully featured.
]]

---@type vim.lsp.Config
return {
  cmd = { 'jedi-language-server' },
  filetypes = { 'python' },
  ---@param client vim.lsp.Client
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = nil
    client.server_capabilities.codeLensProvider = nil
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.renameProvider = nil
    client.server_capabilities.definitionProvider = nil
    client.server_capabilities.foldingRangeProvider = nil
    client.server_capabilities.codeActionProvider = nil

    client.server_capabilities.hoverProvider = true
    client.server_capabilities.definitionProvider = true
  end,
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
  init_options = {
      -- stylua: ignore start
    completion = {
      disableSnippets = false,  -- default: false
      resolveEagerly = false,   -- default: false, should only be set to true if lang client doesnt support `completionItem/resolve`
    },
    --[[ leave diagnostics to ruff ]]
    diagnostics = {
      -- stylua: ignore start
      enable = false,    -- default: false
      didOpen = false,   -- default: true
      didChange = false, -- default: true
      didSave = false,   -- default: true
    },
    hover = { enable = true },
    semanticTokens = { enable = true }, -- default: false
    jediSettings = {
      autoImportModules = {},
      caseInsensitiveCompletion = false, -- default: true
    },
    markupKindPreferred = { "markdown", "plaintext" }, -- default: "markdown"
    -- stylua: ignore stop
  },
  single_file_support = true,
}
