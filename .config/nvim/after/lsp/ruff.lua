local fn = vim.fn
-- Repository: https://github.com/astral-sh/ruff
-- Documentation: https://docs.astral.sh/ruff/editors/
-- Install: `uv tool install ruff@latest`
---@type vim.lsp.Config
-- return {
--   -- cmd = { 'ruff', 'server' },
--   -- filetypes = { 'python' },
--   -- root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml' },
--   -- single_file_support = true,
--   init_options = {
--     settings = {
--       logLevel = 'debug',
--       logFile = vim.fn.stdpath('log') .. '/lsp.ruff.log',
--     },
--   },
-- }

---@type vim.lsp.Config
return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  ---@param client vim.lsp.Client
  on_attach = function(client)
    -- if client.server_capabilities then
    client.server_capabilities.hoverProvider = false
    --[[ conform might actually need to use the lsp so ...]]
    -- client.server_capabilities.documentFormattingProvider = false -- Conform ruff_format
    -- client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.notebookDocumentSync = false
    -- end
  end,
  root_markers = {
    {
      'ruff.toml',
      '.ruff.toml',
      'pyproject.toml',
      '.venv',
      'requirements.txt',
      'setup.py',
    },
    '.git',
  },
  single_file_support = true,
  init_options = {
    loglevel = 'debug',
    logFile = fn.stdpath('log') .. '/lsp.ruff.log',
    settings = {
      configurationPreferences = 'filesystemFirst',
      linelength = 80,
      showSyntaxErrors = true,
      organizeImports = true,
      fixAll = true,
      codeAction = {
        disableRuleComment = { enable = true },
        fixViolation = { enable = true },
      },
      lint = {
        enable = true,
        ignore = {
          'W29',
          'UP039',
          'TRY003',
          'SIM300',
          'S311',
          'S301',
          'S101',
          'RET505',
          'RET504',
          'PLR5501',
          'PLR2004',
          'PLR0915',
          'PLR0913',
          'PIE808',
          'I',
          'F501',
          'F401',
          'E731',
          'E702',
          'E50',
          'E40',
          'E111',
          'E114',
          'COM812',
          'C901',
          'B007',
        },
        select = {
          'I',
          'AIR',
          'PLW',
          'PLR',
        },
        preview = true,
      },
      format = {
        ignore = {
          'W29',
          'UP039',
          'TRY003',
          'SIM300',
          'S311',
          'S301',
          'S101',
          'RET505',
          'RET504',
          'PLR5501',
          'PLR2004',
          'PLR0915',
          'PLR0913',
          'PIE808',
          'I',
          'F501',
          'F401',
          'E731',
          'E702',
          'E50',
          'E40',
          'E111',
          'E114',
          'COM812',
          'C901',
          'B007',
        },
        preview = true,
      },
      args = {
        '--preview',
        '--ignore' .. table.concat({
          'W29',
          'UP039',
          'TRY003',
          'SIM300',
          'S311',
          'S301',
          'S101',
          'RET505',
          'RET504',
          'PLR5501',
          'PLR2004',
          'PLR0915',
          'PLR0913',
          'PIE808',
          'I',
          'F501',
          'F401',
          'E731',
          'E702',
          'E50',
          'E40',
          'E111',
          'E114',
          'COM812',
          'C901',
          'B007',
        }, ','),
      },
    },
  },
  capabilities = {
    general = {
      positionEncodings = { 'utf-16' },
    },
  },
  commands = {
    RuffAutoFix = {
      function()
        -- local params = vim.lsp.util.make_range_params()
        -- params['command'] = 'ruff.fixAll'
        -- vim.lsp.buf.execute_command(params)
        return vim.lsp.buf.execute_command {
          command = 'ruff.applyAutoFix',
          arguments = {
            { uri = vim.uri_from_bufnr(0) },
          },
        }
      end,
      description = 'Ruff: Fix all auto-fixable problems',
    },
    RuffOrganizeImports = {
      function()
        vim.lsp.buf.execute_command {
          command = 'ruff.applyOrganizeImports',
          arguments = {
            { uri = vim.uri_from_bufnr(0) },
          },
        }
      end,
      description = 'Ruff: Format Imports',
    },
  },
}
