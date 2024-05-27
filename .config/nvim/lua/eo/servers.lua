---@diagnostic disable: missing-fields
-- if not eo then return end
-- local boarder = eo.ui.current.border
-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

local function strsplit(s, delim)
  local result = {}
  for match in (s .. delim):gmatch('(.-)' .. delim) do
    table.insert(result, match)
  end
  return result
end

local function quarto_path()
  local f = assert(io.popen('quarto --paths', 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return strsplit(s, '\n')[2]
end

local lua_lib_files = vim.api.nvim_get_runtime_file('', true)
local lua_plugin_paths, resource_path = {}, quarto_path()
-- local resource_path = quarto_path()
if resource_path == nil then
  vim.notify_once('quarto not found, lua library files not loaded')
else
  table.insert(lua_lib_files, resource_path .. '/lua-types')
  table.insert(lua_plugin_paths, resource_path .. 'lua-plugin/plugin.lua')
end

-- local on_attach = function(client, bufnr)
--   if client.name == 'ruff_lsp' then
--     -- disable hover in favor of Pyright|jedi
--     client.server_capabilities.hoverProvider = false
--   elseif (client.name == 'pyright') or (client.name == 'python-lsp-server') then
--     client.server_capabilities.hoverProvider = false
--     -- table.unpack { pyright = { disableOrganizeImports = true } }
--   else
--     client.server_capabilities.hoverProvider = true
--   end
--   client.server_capabilities.documentFormattingProvider = false
--   client.server_capabilities.documentRangeFormattingProvider = false
-- end
local md_root_files = { '.marksman.toml', '_quarto.yaml', '_quarto.yml' }

local servers = {
  taplo = {
    init_options = {
      configurationSection = 'evenBetterToml',
      cachePath= vim.NIL,
    },
  },
  vimls = {},
  -- dotls = {},
  -- sqlls = {},
  jsonls = {
    settings = {
      json = {
        schemas = function() require('schemastore').json.schemas() end,
        filetypes = { 'json', 'jsonc', 'json5' },
        validate = { enable = true },
        format = { enable = false },
      },
    },
  },
  marksman = {
    filetypes = { 'markdown', 'quarto' },
    -- root_dir = function(fname, ...)
      -- local util = require('lspconfig.util')
      -- require('lspconfig/util').root_pattern('.git', '_quarto.yml', '.marksman.toml')
      -- return util.root_pattern('_quarto.yml', '.marksman.toml')(fname) or util.path.dirname(...)
    -- end,
    root_dir = vim.fs.dirname(vim.fs.find({ md_root_dirs }, { upward = true })[1]),
  },
  bashls = {
    filetypes = {
      'sh',
      'bash',
      'zsh',
      'env',
    },
  },
  julials = {
    settings = {
      julia = {
        symbolCacheDownload = true,
        enableTelemetry = false,
      },
    },
  },
  basedpyright = {
    on_attach = function(client)
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.signatureHelpProvider = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    basedpyright = {
      settings = {
        disableLanguageServices = true,
        disableOrganizeImports = true,
        -- completeFunctionParens = true,
        -- autoImportCompletions = false,
        basedpyright = {
          analysis = {
            useLibraryCodeForTypes = true,
            autoSearchPaths = true,
            typeCheckingMode = 'off', -- 'off' | 'basic' | 'standard' | 'strict' | 'all'
            -- diagnosticMode = 'openFilesOnly',
            diagnosticMode = 'off',
            diagnosticSeverityOverrides = {
              reportUnusedVariable = 'none',
              reportUnusedCallResult = 'none',
              reportUnusedExpression = 'none',
              reportUnknownMemberType = 'none',
              reportUnknownLambdaType = 'none',
              reportUnknownParameterType = 'none',
              reportMissingParameterType = 'none',
              reportUnknownVariableType = 'none',
              reportUnknownArgumentType = 'none',
              reportImplicitOverride = 'none',
              reportAny = 'none',
            },
          },
        },
      },
    },
  },
  ruff_lsp = {
    on_attach = function(ruff)
      ruff.server_capabilities.hoverProvider = false
      ruff.server_capabilities.signatureHelpProvider = false
      ruff.server_capabilities.documentFormattingProvider = true
      ruff.server_capabilities.documentRangeFormattingProvider = true
    end,
    -- handers = {
    --   -- ['textDocument/hover'] = function(...) end,
    --   ['textDocument/publishDiagnostics'] = function(...) end,
    -- },
    -- on_attach = on_attach,
    init_options = {
      settings = {
        organizeImports = true,
        fixAll = true,
        codeAction = { fixViolation = { enable = true } },
        -- args = {
        --   '--extend-select',
        --   'W,C90,UP,ASYNC,S,B,A,COM,C4,DTZ,T10,EXE,ISC,ICN,G,INP,PIE,PYI,PT,RET,SIM,TID,TCH,PL,TRY,PD,NPY,PERF',
        --   '--ignore',
        --   'E40,E50,W29,PLR0913,S101,RET504,RET505,C901,TRY003,F401,F501,PLR0915,COM812,PLR2004,S301,S311,PIE808,B007s,UP039,SIM300,PLR5501,I',
        -- },
      },
    },
  },
  jedi_language_server = {
    -- on_attach = on_attach,
    on_attach = function(jedi)
      jedi.server_capabilities.hoverProvider = true
      jedi.server_capabilities.signatureHelpProvider = true
      jedi.server_capabilities.documentFormattingProvider = false
      jedi.server_capabilities.documentRangeFormattingProvider = false
    end,
    initializationOptions = {
      diagnostics = {
        enable = false,
        didOpen = false,
        didChange = false,
        didSave = false,
      },
      completion = {
        disableSnippets = false,
        resolveEagerly = true,
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        -- hover = true,
        -- completion = true,
        -- validate = true,
        format = { enable = false },
        schemaStore = {
          -- must disable built-in schemaStore support if you want to use SchemaStore.nvim & its
          -- advanced options like `ignore`
          enable = false,
          -- avoid TypeError: Cannot read properties of undefined (reading 'length')
          utl = '',
        },
        schemas = require('schemastore').yaml.schemas {},
      },
    },
  },
  lua_ls = {
    -- before_init = require('neodev.lsp').before_init,
    -- on_attach = function(client)
    --   client.server_capabilities.documentFormattingProvider = false
    --   client.server_capabilities.documentRangeFormattingProvider = false
    -- end,
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          plugin = lua_plugin_paths,
        },
        codeLens = { enable = true },
        misc = { parameters = {} },
        doc = { privateName = '^_' },
        hint = {
          enable = true,
          -- await = true,
          setType = false,
          paramType = true,
          paramName = 'Disable', -- 'Disable' | 'Literal'
          semicolon = 'Disable',
          arrayIndex = 'Disable', -- show hints ('auto') only when table is >3 items, or tbl is mixed; 'Disable'
        },
        format = { enable = false },
        diagnostics = {
          -- disable = { 'unused-local', 'trailing-space' },
          globals = {
            'quarto',
            'pandoc',
            'io',
            'string',
            'print',
            'bit',
            'require',
            'table',
            'eo',
            'hs',
            'map',
            'vim',
            'P',
            'describe',
            'it',
            'before_each',
            'after_each',
            'pending',
          },
        },
        completion = {
          autoRequire = false,
          keywordSnippet = false,
          workspaceWord = true, -- folke -> true
          callSnippet = 'Replace',
        },
        workspace = {
          maxPreload = 10000,
          checkThirdParty = false,
          -- ignoreDir = { '.*', 'vim/plugged', 'config/nvim', 'nvim/lua' },
          -- library = { lua_lib_files, function() return require('neodev.config').types() end },
          -- library = { lua_lib_files, require('neodev.config').types() },
          library = { lua_lib_files },
        },
        telemetry = { enable = false },
      },
    },
  },
}
-- return function(name)
--@eo razak17/nvim

---Get the configuration for a specific language server
---@param name string?
---@return table<string, any>?
return function(name)
  local config = servers[name] or {}
  if not config then return nil end
  if type(config) == 'function' then config = config() end
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  if ok then config.capabilities = cmp_nvim_lsp.default_capabilities() end
  config.capabilities = vim.tbl_deep_extend('keep', config.capabilities or {}, {
    textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } },
  })
  return config
end
