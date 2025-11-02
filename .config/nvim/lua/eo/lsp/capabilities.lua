local lsp = vim.lsp

local function make_capabilities()
  -- local has_blink, blink = pcall(require, 'blink.cmp')
  -- local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

  local capabilities = lsp.protocol.make_client_capabilities()
  --   local capabilities = vim.tbl_deep_extend("force", {},
  --     lsp.protocol.make_client_capabilities(),
  --     has_cmp and cmp_nvim_lsp.default_capabilities() or {},
  --     has_blink and blink.get_lsp_capabilities() or {},
  --     opts.capabilities or {}
  -- )

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  capabilities.workspace = {
    didChangeWatchedFiles = { dynamicRegistration = false },
    diagnostics = { refreshSupport = true },
  }

  capabilities.experimental = {
    hoverActions = true,
    hoverRange = true,
    serverStatusNotification = true,
    codeActionGroup = true,
    ssr = true,
    commands = {
      'editor.action.triggerParameterHints',
    },
  }

  capabilities.textDocument = {
    semanticTokens = {
      multilineTokenSupport = true,
    },
    completion = {
      completionItem = {
        contextSupport = true,
        snippetSupport = true,
        deprecatedSupport = true,
        commitCharacterSupport = true,
        resolveSupport = {
          properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
          },
        },
        labelDetailsSupport = true,
        documentationFormat = { 'markdown', 'plaintext' },
      },
    },
  }

  return require('blink.cmp').get_lsp_capabilities(capabilities, false)
  -- return vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, true))
  -- return vim.tbl_deep_extend(
  --   'force',
  --   {},
  --   lsp.protocol.make_client_capabilities(),
  --   has_cmp and cmp_nvim_lsp.default_capabilities() or {},
  --   has_blink and blink.get_lsp_capabilities(capabilities, false) or {}
  -- )
end

return {
  make_capabilities = make_capabilities,
}
