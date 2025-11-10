-- local M = {}

local function make_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- local capabilities = vim.tbl_deep_extend(
  --   'force',
  --   vim.lsp.protocol.make_client_capabilities(),
  --   require('blink.cmp').get_lsp_capabilities({}, false)
  -- )

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
  }

  -- vim.tbl_deep_extend('force', {}, capabilities.textDocument.completion, completion.textDocument.completion)

  return require('blink.cmp').get_lsp_capabilities(capabilities, false)
end

return {
  make_capabilities = make_capabilities,
}

-- local capabilities = vim.tbl_deep_extend(
--   'force',
--   lsp.protocol.make_client_capabilities(),
--   require('blink.cmp').get_lsp_capabilities({}, false)
-- )

-- return vim.tbl_deep_extend('force', capabilities, {
--   textDocument = {
--     foldingRange = {
--       dynamicRegistration = false,
--       lineFoldingOnly = true,
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
--     semanticTokens = { multilineTokenSupport = true },
--     completion = {
--       completionItem = {
--         contextSupport = true,
--         snippetSupport = true,
--         deprecatedSupport = true,
--         commitCharacterSupport = true,
--         resolveSupport = {
--           properties = {
--             'documentation',
--             'detail',
--             'additionalTextEdits',
--           },
--         },
--         tagSupport = {
--           valueSet = { 1 },
--         },
--         labelDetailsSupport = true,
--         documentationFormat = {
--           'markdown',
--           'plaintext',
--         },
--       },
--     },
--   },
-- })
