---@type vim.lsp.Config
return {
  cmd = { 'yaml-language-server', '--stdio' },
  -- filetypes = {
  --   'yaml',
  --   'yaml.docker-compose',
  --   'yaml.gitlab',
  --   'yaml.helm-values',
  -- },
  settings = {
    redhat = {
      telemetry = { enabled = false },
    },
    yaml = {
      format = { enable = false },
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = require('schemastore').yaml.schemas {},
    },
  },
}
