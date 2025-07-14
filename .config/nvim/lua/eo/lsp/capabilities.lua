local lsp = vim.lsp

local function make_capabilities()
  local capabilities = lsp.protocol.make_client_capabilities()

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

  return require('blink.cmp').get_lsp_capabilities(capabilities, true)
  -- return vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities({}, true))
end

return {
  make_capabilities = make_capabilities,
}
