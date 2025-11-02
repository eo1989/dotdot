local api, fn, fs, lsp = vim.api, vim.fn, vim.fs, vim.lsp

---@type vim.lsp.config
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  ---@param client vim.lsp.Client
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
      disableOrganizeImports = true, -- |> ruff
      analysis = {
        typeCheckingMode = 'off',
        autoImportCompletions = true, -- |> ruff
        autoSearchPaths = true, -- already done in base config
        diagnosticMode = false, --'openFilesOnly' |> ruff
        ignore = { '*' },
        diagnosticSeverityOverrides = {
          reportAny = 'none',
          reportArgumentType = 'none', -- |> ruff
          reportAssignmentType = 'none',
          reportAttributeAccessIssue = 'none',
          reportDeprecated = 'none',
          reportExplicitAny = 'none',
          reportGeneralTypeIssues = 'none',
          reportMissingTypeStubs = 'none',
          reportOptionalMemberAccess = 'none',
          reportUndefinedVariable = 'none', -- |> ruff
          reportUnreachable = 'none',
          reportUnusedCallResult = 'none',
          reportUnusedFunction = 'none',
          reportUnusedImport = 'none', -- |> ruff
        },
        loglevel = 'error',
        stubpath = fn.expand('~') .. '/.local/share/nvim/lazy/python-type-stubs/stubs',
        useLibraryCodeForTypes = true, -- already true in base config
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
