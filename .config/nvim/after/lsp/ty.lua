local fn, fs = vim.fn, vim.fs

--[[
  ty.toml files take precedence over pyproject.toml files, so if both ty.toml and pyproject.toml
  files are present in a directory, configuration will be read from ty.toml, and the [tool.ty]
  section in the accompanying pyproject.toml will be ignored.
--]]

---@type vim.lsp.Config
return {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  handlers = {
    ['window/showMessage'] = function(_, result)
      if result and result.type == vim.lsp.protocol.MessageType.Error then
        return -- silence error notifications from ty
      end
    end,
  },
  single_file_support = true,
  root_markers = {
    {
      'pyproject.toml',
      'requirements.txt',
      'ty.toml',
      'Pipfile',
      'setup.py',
      'setup.cfg',
    },
    '.git',
  },
  ---@param client vim.lsp.Client
  -- on_attach = function(client)
  --   -- let treesitter handle semantic tokens
  --   -- client.server_capabilities.semanticTokensProvider = false
  --   -- client.server_capabilities.documentRangeFormattingProvider = false
  --   -- client.server_capabilities.documentOnTypeFormattingProvider = nil
  --   -- client.server_capabilities.documentFormattingProvider = false
  --   -- client.server_capabilities.hoverProvider = nil
  --   -- client.server_capabilities.inlayHintProvider = nil
  --   -- client.server_capabilities.completionProvider = nil
  --   -- if client.server_capabilities then
  --   -- end
  -- end,
  -- Silence ty server panics (e.g. https://github.com/astral-sh/ty/issues/2401)
  on_error = function(_, _) end,
  init_options = {
    logLevel = 'debug',
    logFile = fn.stdpath('log') .. '/lsp.ty.log',
  },
  settings = {
    ty = {
      disableLanguageServices = false,
      diagnosticMode = 'openFilesOnly', -- 'off', 'openFilesOnly', 'workspace'
      showSyntaxErrors = true,
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
      completions = {
        autoImport = false,
      },
      configuration = {
        rules = {
          ['unresolved-reference'] = 'warn',
        },
      },
      -- experimental = {
      --   rename = true,
      --   autoImport = false,
      -- },
    },
  },
}
