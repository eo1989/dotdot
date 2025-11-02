-- return {
--   cmd = { 'vscode-json-language-server', '--stdio' },
--   filetypes = { 'json', 'jsonc' },
--   root_markers = { '.git' },
--   single_file_support = true,
--   init_options = {
--     provideFormatter = true,
--   },
--   settings = {
--     -- See setting options
--     -- https://github.com/microsoft/vscode/tree/main/extensions/json-language-features/server#settings
--     json = {
--       -- Use JSON Schema Store (SchemaStore.nvim)
--       schemas = require('schemastore').json.schemas(),
--       validate = { enable = true },
--     },
--   },
-- }

---@type vim.lsp.Config
return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  single_file_support = true,
  --[[---@type table<vim.lsp.protocol.Methods, lsp.Handler> ]]
  -- handlers = {
  --   ---@type lsp.Handler
  --   ['textDocument/publishDiagnostics'] = function(err, result, ctx)
  --     result.diagnostics = vim.tbl_filter(function(diagnostic)
  --       -- disable diagnostics for trailing comma in JSONC
  --       if diagnostic.code == 519 then return false end
  --
  --       return true
  --     end, result.diagnostics)
  --     vim.lsp.handlers[ctx.method](err, result, ctx)
  --   end,
  -- },
  init_options = {
    provideFormatter = false,
  },
  --- @param client vim.lsp.Client
  -- on_init = function(client)
  --   -- local schemas = nvim.file.read(nvim.file.xdg_config('schemas.json')) or '{}'
  --
  --   local schemas = vim.fn.readfile(vim.fn.expand('~/.config/' .. 'schemas.json') or {}) --  .file.read(nvim.file.xdg_config('schemas.json')) or '{}'
  --
  --   ---@diagnostic disable-next-line: inject-field, need-check-nil
  --   client.config.settings.json.schemas = require('schemastore').json.schemas {
  --     extra = vim.json.decode(schemas),
  --   }
  --
  --   client:notify(vim.lsp.protocol.Methods.workspace_didChangeConfiguration, { settings = client.config.settings })
  -- end,
  -- settings = {
  --   json = {
  --     format = {
  --       enable = true,
  --     },
  --     -- schemas = {},
  --     schemas = require('schemastore').json.schemas(),
  --     validate = {
  --       enable = true,
  --     },
  --   },
  -- },
}
