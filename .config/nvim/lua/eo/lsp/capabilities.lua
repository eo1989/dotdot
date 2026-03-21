-- local capabilities = vim.lsp.protocol.make_client_capabilities
-- local capabilities = nil

local capabilities = {
  textDocument = {
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
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
    semanticTokens = { multilineTokenSupport = true },
  },
  workspace = {
    didChangeWatchedFiles = { dynamicRegistration = false },
    diagnostics = { refreshSupport = true },
  },
  experimental = {
    hoverActions = true,
    hoverRange = true,
    serverStatusNotification = true,
    codeActionGroup = true,
    ssr = true,
    commands = {
      'editor.action.triggerParameterHints',
    },
  },
}

capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

-- if pcall(require, 'blink.cmp') then
--   capabilities = require('blink.cmp').get_lsp_capabilities {
--     textDocument = {
--       foldingRange = {
--         dynamicRegistration = false,
--         lineFoldingOnly = true,
--       },
--       completion = {
--         completionItem = {
--           contextSupport = true,
--           snippetSupport = true,
--           deprecatedSupport = true,
--           commitCharacterSupport = true,
--           resolveSupport = {
--             properties = {
--               'documentation',
--               'detail',
--               'additionalTextEdits',
--             },
--           },
--           labelDetailsSupport = true,
--           documentationFormat = { 'markdown', 'plaintext' },
--         },
--       },
--       semanticTokens = { multilineTokenSupport = true },
--     },
--     workspace = {
--       didChangeWatchedFiles = { dynamicRegistration = false },
--       diagnostics = { refreshSupport = true },
--     },
--     experimental = {
--       hoverActions = true,
--       hoverRange = true,
--       serverStatusNotification = true,
--       codeActionGroup = true,
--       ssr = true,
--       commands = {
--         'editor.action.triggerParameterHints',
--       },
--     },
--   }
-- end

return {
  capabilities = capabilities,
}
