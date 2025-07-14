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
  -- cmd = { 'ruff', 'server' },
  -- filetypes = {
  --   'python',
  -- },
  root_markers = {
    {
      '.ruff.toml',
      'pyproject.toml',
      'requirements.txt',
      'ruff.toml',
      'setup.py',
    },
    '.git',
  },
  single_file_support = true,
  on_attach = function(client)
    -- if client.server_capabilities then
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentFormattingProvider = false -- Conform ruff_format
    client.server_capabilities.documentRangeFormattingProvider = false
    -- end
  end,
  init_options = {
    loglevel = 'debug',
    logFile = vim.fn.expand('~') .. '/.local/state/nvim/ruff.log',
    organizeImports = false,
    fixAll = true,
    codeAction = {
      fixViolation = { enable = true },
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
