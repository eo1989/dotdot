local fn, fs = vim.fn, vim.fs

--[[
  ty.toml files take precedence over pyproject.toml files, so if both ty.toml and pyproject.toml
  files are present in a directory, configuration will be read from ty.toml, and the [tool.ty]
  section in the accompanying pyproject.toml will be ignored.
--]]

---@type vim.lsp.Config
return {
  ---@param client vim.lsp.Client
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  ---@param client vim.lsp.Client
  single_file_support = true,
  root_markers = { { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt' }, '.git' },
  -- root_dir = fs.root(0, { 'pyproject.toml', '.git' }),
  on_attach = function(client)
    -- let treesitter handle semantic tokens
    -- client.server_capabilities.semanticTokensProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentOnTypeFormattingProvider = nil
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.hoverProvider = nil
    client.server_capabilities.inlayHintProvider = nil
    client.server_capabilities.completionProvider = nil
  end,
  init_options = {
    logLevel = 'debug',
    logFile = fn.stdpath('log') .. '/lsp.ty.log',
    settings = {
      ty = {
        experimental = {
          rename = false,
          autoImport = false,
        },
      },
    },
  },
}
