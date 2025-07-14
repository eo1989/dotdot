local fn, fs = vim.fn, vim.fs

---@type vim.lsp.config
return {
  -- cmd = { 'basedpyright-langserver', '--stdio' },
  -- filetypes = 'python',
  ---@param client vim.lsp.Client
  single_file_support = true,
  on_attach = function(client)
    if client.server_capabilities then
      client.server_capabilities.semanticTokensProvider = nil
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.documentFormattingProvider = false
    end
    -- client.server_capabilities.documentSymbolProvider = false
    -- client.server_capabilities.completionProvider = false
    -- client.server_capabilities.hoverProvider = false
    -- client.server_capabilities.signatureHelpProvider = false
    -- client.server_capabilities.renameProvider = false
    -- client.server_capabilities.codeActionProvider = false
  end,
  -- root_markers = {
  --   {
  --     'Pipfile',
  --     'pyrightconfig.json',
  --     'requirements.txt',
  --     'pyproject.toml',
  --     'setup.cfg',
  --     'setup.py',
  --   },
  --   '.git',
  -- },
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        -- autoSearchPaths = true, -- already done in base config
        -- diagnosticMode = 'workspace', --'openFilesOnly' |> ruff
        reportMissingTypeStubs = false,
        reportUndefinedVariable = 'off', -- |> ruff
        reportUnreachable = 'off',
        reportUnusedImport = 'off', -- |> ruff
        typeCheckingMode = 'off', -- 'off', 'basic', 'strict'
        -- useLibraryCodeForTypes = false, -- already true in base config
      },
      disableOrganizeImports = true, -- |> ruff
    },
    -- python = {
    --   analysis = {
    --     stubPath = fn.expand('~') .. '/Dev/scripts/ruff/crates/ty_vendored/ty_extensions',
    --   },
    -- },
  },
  before_init = function(_, config)
    if config.root_dir == nil then return end

    local venv_dir = vim.fs.joinpath(config.root_dir, '.venv')
    if eo.path_exists(venv_dir) then
      config.settings.python.venvPath = venv_dir
      config.settings.python.pythonPath = fs.joinpath(venv_dir, 'bin', 'python')
      return
    end
  end,
}
