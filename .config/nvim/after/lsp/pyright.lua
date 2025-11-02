local api, fn, fs, lsp = vim.api, vim.fn, vim.fs, vim.lsp

---@type vim.lsp.config
return {
  -- cmd = { 'pyright-langserver', '--stdio' },
  -- filetypes = 'python',
  -- single_file_support = true,
  on_attach = function(client)
    -- let treesitter handle semantic tokens
    -- client.server_capabilities.semanticTokensProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentFormattingProvider = false
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
  settings = {
    analysis = {
      stubPath = fn.expand('~') .. '/.local/share/nvim/lazy/python-type-stubs/stubs',
      autoImportCompletions = false, -- |> ruff
      autoSearchPaths = true, -- already done in base config
      diagnosticMode = false, --'openFilesOnly' |> ruff
      useLibraryCodeForTypes = true, -- already true in base config
      typeCheckingMode = 'off', -- 'off', 'basic', 'strict'
      ignore = {
        -- reportMissingTypeStubs = false,
        -- reportUndefinedVariable = 'off', -- |> ruff
        -- reportUnreachable = 'off',
        -- reportUnusedImport = 'off', -- |> ruff
        '*',
      },
    },
    disableOrganizeImports = true, -- |> ruff
  },
  -- before_init = function(_, config)
  --   if config.root_dir == nil then return end
  --
  --   local venv_dir = vim.fs.joinpath(config.root_dir, '.venv')
  --
  --   if eo.path_exists(venv_dir) ~= nil then
  --     config.settings.python.venvPath = venv_dir
  --     config.settings.python.pythonPath = fs.joinpath(venv_dir, 'bin', 'python')
  --     return
  --   end
  -- end,
}
