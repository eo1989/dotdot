local api, fn, fs, lsp = vim.api, vim.fn, vim.fs, vim.lsp

---@type vim.lsp.config
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  ---@param client vim.lsp.ClientConfig
  on_attach = function(client)
    -- let treesitter handle semantic tokens
    -- client.server_capabilities.semanticTokensProvider = false
    -- client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentOnTypeFormattingProvider = false
    -- client.server_capabilities.documentFormattingProvider = false
    -- client.server_capabilities.hoverProvider = nil
  end,
  root_markers = {
    {
      'pyrightconfig.json',
      'pyproject.toml',
      'Pipfile',
      'setup.cfg',
      'setup.py',
      'requirements.txt',
    },
    '.git',
  },
  single_file_support = true,
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      disableLanguageServices = false,
      disableTaggedHints = false,
      openFilesOnly = true,
      analysis = {
        autoImportCompletions = false,
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'off',
        autoFormatStrings = true,
        useLibraryCodeForTypes = true,
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          callArgumentNamesMatching = false,
          functionReturnTypes = true,
          genericTypes = true,
        },
        -- ignore = { '*' },
        diagnosticSeverityOverrides = {
          -- reportAny = 'none',
          -- reportArgumentType = 'none',
          -- reportAssignmentType = 'none',
          -- reportAttributeAccessIssue = 'none',
          -- reportDeprecated = 'none',
          -- reportExplicitAny = 'none',
          -- reportGeneralTypeIssues = 'none',
          -- reportMissingTypeStubs = 'none',
          -- reportOptionalMemberAccess = 'none',
          -- reportUndefinedVariable = 'none',
          -- reportUnreachable = 'none',
          -- reportUnusedCallResult = 'none',
          -- reportUnusedFunction = 'none',
          -- reportUnusedImport = 'none',
          reportAny = false,
          reportArgumentType = false,
          reportAssignmentType = false,
          reportAttributeAccessIssue = false,
          reportDeprecated = false,
          reportExplicitAny = false,
          reportGeneralTypeIssues = false,
          reportMissingTypeStubs = false,
          reportOptionalMemberAccess = false,
          reportUndefinedVariable = false,
          reportUnreachable = false,
          reportUnusedCallResult = false,
          reportUnusedFunction = false,
          reportUnusedImport = false,
        },
        loglevel = 'error',
        stubpath = fn.expand('~') .. '/.local/share/nvim/lazy/python-type-stubs/stubs',
      },
    },
  },
  -- before_init = function(_, config)
  --   if config.root_dir == nil then return end
  --
  --   local venv_dir = vim.fs.joinpath(config.root_dir, '.venv')
  --   if eo.path_exists(venv_dir) ~= nil then
  --     config.settings.python.venvPath = venv_dir
  --     config.settings.python.pythonPath = fs.joinpath(venv_dir, 'bin', 'python')
  --     return
  --   end
  -- end,
}
