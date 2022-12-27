---@diagnostic disable: unused-function
-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//
local fn, fmt, env = vim.fn, string.format, vim.env

-- local semantic = vim.F.npcall(require, 'nvim-semantic-tokens')
-- local semantic = as.require('nvim-semantic-tokens')
-- local lspconfig = require('lspconfig')

--FUCK: NOT WORKING
-- local pylance = function()
--   return require("as.pylance_")
-- end

-- local pathh = require("mason-core.path")
-- local patth = require("lspconfig")
-- local function py_path(workspace)
--   if env.VIRTUAL_ENV then
--     return pathh.join(env.VIRTUAL_ENV, "bin", "python")
--   end
--   if fn.filereadable(pathh.concat { workspace, "poetry.lock" }) then
--     local venv = fn.trim(fn.system("poetry env info -p"))
--     return pathh.concat({ venv, "bin", "python" })
--   end
--   return fn.exepath("python3") or fn.exepath("python") or "python"
-- end

-- This function allows reading a per project "settings.json" file in the `.vim` directory of the project.
---@param client table<string, any>
---@return boolean
local function on_init(client)
  local settings = client.workspace_folders[1].name .. '/.vim/settings.json'

  if fn.filereadable(settings) == 0 then
    return true
  end
  local ok, json = pcall(fn.readfile, settings)
  if not ok then
    return true
  end

  local overrides = vim.json.decode(table.concat(json, '\n'))

  for name, config in pairs(overrides) do
    if name == client.name then
      client.config = vim.tbl_deep_extend('force', client.config, config)
      client.notify('workspace/didChangeConfiguration')

      vim.schedule(function()
        local path = fn.fnamemodify(settings, ':~:.')
        local msg = fmt('loaded local settings for %s from %s', client.name, path)
        vim.notify_once(msg, 'info', { title = 'LSP Settings' })
      end)
    end
  end
  return true
end

local servers = {
  jsonls = true,
  -- julials = true,
  julials = {
    settings = {
      julia = {
        symbolCacheDownload = true,
        editor = 'neovim',
        enableTelemetry = false,
        execution = {
          codeInREPL = true,
          inlineResultsForCellEvaluation = false,
        },
      },
    },
  },
  bashls = {
    bashIde ={
      -- explainshellEndpoint = 'localhost',
      globpattern =  { "**/*@(.sh|.inc|.bash|.command|.zsh|make)" },
    },
    filetypes = {
      "sh", "bash", "zsh", "make"
    },
    settings = {},
  },
  vimls = true,
  marksman = false,
  -- FIXME: Still cant get pylance to work for some reason!
  -- pylance = pylance,
  -- pylance = function()
  --   return require("as.pylance_.").config
  -- end,
  pyright = {
    handlers = {
      ['textDocument/publishDiagnostics'] = function(...) end
    },
    settings = {
      python = {
        -- pythonPath = py_path(client.config.root_dir),
        analysis = {
          typeCheckingMode = 'basic',
          autoSearchPaths = true,
          indexing = false,
          diagnosticMode = 'openFilesOnly', --'workspace'
          useLibraryCodeForTypes = true,
          completeFunctionParens = true,
          inlayHints = {
            variableTypes = false,
            functionReturnTypes = true,
          },
          stubPath = table.concat({
            vim.fn.stdpath "data",
            "site",
            "pack",
            "packer",
            "opt",
            "python-type-stubs",
          }),
        },
      },
      pyright = {
        disableDiagnostics = true,
      },
    },
  },
  pylsp = false,
  bufls = false,
  prosemd_lsp = true,
  --- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          generate = true,
          gc_details = false,
          test = true,
          tidy = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          unusedparams = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { '-node_modules' },
        completionDocumentation = true,
        deepCompletion = true,
        semanticTokens = true,
        verboseOutput = false, -- useful for debugging when true
      },
    },
  },
  sourcekit = {
    filetypes = { 'swift', 'objective-c', 'objective-cpp' },
  },
  yamlls = {
    settings = {
      yaml = {
        customTags = {
          '!reference sequence', -- necessary for gitlab-ci.yaml files
        },
      },
    },
  },
  sqls = function()
    return {
      root_dir = require('lspconfig').util.root_pattern('.git'),
      single_file_support = false,
      on_new_config = function(new_config, new_rootdir)
        table.insert(new_config.cmd, '-config')
        table.insert(new_config.cmd, new_rootdir .. '/.config.yaml')
      end,
      update = function(on_attach, opts)
        local function code_action(range_given, line1, line2)
          if range_given then
            vim.lsp.code_action({
              range = {
                start = { line1, 0 },
                ["end"] = { line2, 99999999 },
              },
            })
          else
            vim.lsp.buf.code_action()
          end
        end
      end
    }
  end,
  --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
  sumneko_lua = function()
    local path = vim.split(package.path, ';')
    table.insert(path, 'lua/?.lua')
    table.insert(path, 'lua/?/init.lua')

    local plugins = ('%s/site/pack/packer'):format(fn.stdpath('data'))
    local emmy = ('%s/start/emmylua-nvim'):format(plugins)
    local plenary = ('%s/start/plenary.nvim'):format(plugins)
    local packer = ('%s/opt/packer.nvim'):format(plugins)
    -- local neotest = ('%s/opt/neotest'):format(plugins)
    -- local neodev = require('neodev').setup({
    --   library = {
    --     enabled = true,
    --     runtime = true,
    --     types = true,
    --     plugins = true,
    --   }
    -- })

    return {
      settings = {
        Lua = {
          runtime = {
            path = path,
            version = 'LuaJIT',
          },
          hover = {
            expandAlias = false,
          },
          hint = {
            enable = true,
            paramType = true,
            paramName = true,
            arrayIndex = 'Disable',
            setType = false
          },
          -- type = {
          --   castNumberToInteger = true,
          -- },
          -- IntelliSense = {
          --   traceLocalSet = true,
          -- },
          format = { enable = false },
          diagnostics = {
            globals = {
              'vim',
              'as',
              'P',
              'describe',
              'it',
              'before_each',
              'after_each',
              'packer_plugins',
            },
          },
          completion = {
            keywordSnippet = 'Disable',
            callSnippet = 'Replace',
            displayContext = 4,
            showWord = "Disable",
          },
          workspace = {
            library = {
              fn.expand('$VIMRUNTIME/lua'),
              fn.expand('$VIMRUNTIME/lua/vim/lsp'),
              emmy,
              packer,
              plenary
            },
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end,
}

---Get the configuration for a specific language server
---@param name string
---@return table<string, any>?
return function(name)
  local config = servers[name]
  if not config then return end
  local t = type(config)
  if t == 'boolean' then config = {} end
  if t == 'function' then config = config() end
  config.on_init = on_init

  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  config.capabilities.textDocument.completion.completionItem.snippetSupport = true
  config.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" }
  }
  config.capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

  local ok, cmp_nvim_lsp = as.require('cmp_nvim_lsp')
  if ok then cmp_nvim_lsp.default_capabilities(config.capabilities) end
  return config
end
