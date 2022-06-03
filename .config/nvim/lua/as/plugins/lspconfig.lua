as.lsp = {}

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

-- Show the popup diagnostics window, but only once for the current cursor location
-- by checking whether the word under the cursor has changed.
local function diagnostic_popup()
  local cword = vim.fn.expand('<cword>')
  if cword ~= vim.w.lsp_diagnostics_cword then
    vim.w.lsp_diagnostics_cword = cword
    vim.diagnostic.open_float(0, { scope = 'cursor', focus = false })
  end
end

--- Add lsp autocommands
---@param client table<string, any>
---@param bufnr number
local function setup_autocommands(client, bufnr)
  if client and client.server_capabilities.codeLensProvider then
    as.augroup('LspCodeLens', {
      {
        event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
        buffer = bufnr,
        command = function()
          vim.lsp.codelens.refresh()
        end,
      },
    })
  end
  if client and client.server_capabilities.documentHighlightProvider then
    as.augroup('LspCursorCommands', {
      {
        event = { 'CursorHold' },
        buffer = bufnr,
        command = function()
          diagnostic_popup()
        end,
      },
      {
        event = { 'CursorHold', 'CursorHoldI' },
        buffer = bufnr,
        description = 'LSP: Document Highlight',
        command = function()
          pcall(vim.lsp.buf.document_highlight)
        end,
      },
      {
        event = 'CursorMoved',
        description = 'LSP: Document Highlight (Clear)',
        buffer = bufnr,
        command = function()
          vim.lsp.buf.clear_references()
        end,
      },
    })
  end
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param client table lsp client
local function setup_mappings(client)
  local ok = pcall(require, 'lsp-format')
  local format = ok and '<Cmd>Format<CR>' or vim.lsp.buf.formatting
  local function with_desc(desc)
    return { buffer = 0, desc = desc }
  end

  as.nnoremap(']c', vim.diagnostic.goto_prev, with_desc('lsp: go to prev diagnostic'))
  as.nnoremap('[c', vim.diagnostic.goto_next, with_desc('lsp: go to next diagnostic'))

  if client.server_capabilities.documentFormattingProvider then
    as.nnoremap('<leader>rf', format, with_desc('lsp: format buffer'))
  end

  if client.server_capabilities.codeActionProvider then
    as.nnoremap('<leader>ca', vim.lsp.buf.code_action, with_desc('lsp: code action'))
    as.xnoremap('<leader>ca', vim.lsp.buf.range_code_action, with_desc('lsp: code action'))
  end

  if client.server_capabilities.definitionProvider then
    as.nnoremap('gd', vim.lsp.buf.definition, with_desc('lsp: definition'))
  end
  if client.server_capabilities.referencesProvider then
    as.nnoremap('gr', vim.lsp.buf.references, with_desc('lsp: references'))
  end
  if client.server_capabilities.hoverProvider then
    as.nnoremap('K', vim.lsp.buf.hover, with_desc('lsp: hover'))
  end

  if client.supports_method('textDocument/prepareCallHierarchy') then
    as.nnoremap('gI', vim.lsp.buf.incoming_calls, with_desc('lsp: incoming calls'))
  end

  if client.server_capabilities.implementationProvider then
    as.nnoremap('gi', vim.lsp.buf.implementation, with_desc('lsp: implementation'))
  end

  if client.server_capabilities.typeDefinitionProvider then
    as.nnoremap('<leader>gd', vim.lsp.buf.type_definition, with_desc('lsp: go to type definition'))
  end

  if client.server_capabilities.codeLensProvider then
    as.nnoremap('<leader>cl', vim.lsp.codelens.run, with_desc('lsp: run code lens'))
  end

  if client.server_capabilities.renameProvider then
    as.nnoremap('<leader>rn', vim.lsp.buf.rename, with_desc('lsp: rename'))
  end
end


---@eo {{{
-- local lspconf = require('lspconfig')
-- local notify = require('notify')

-- local function preview_location_callback(_, result, _)
--   if result == nil or vim.tbl_isempty(result) then
--     vim.notify('No definition found.')
--     return nil
--   end
--   if vim.tbl_isempty(result) then
--     vim.lsp.util.preview_location(result[1])
--   else
--     vim.lsp.util.preview_location(result)
--   end
-- end

-- local function peek_definition()
--   local params = vim.lsp.util.make_position_params()
--   return vim.buf_request(0, 'textDocument/definition', params, preview_location_callback)
-- end
---@eo }}}

function as.lsp.on_attach(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client)
  local format_ok, lsp_format = pcall(require, 'lsp-format')
  if format_ok then
    lsp_format.on_attach(client)
  end

  if client.server_capabilities.definitionProvider then
    vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end
end

-----------------------------------------------------------------------------//
-- Language servers
-----------------------------------------------------------------------------//

--- This is a product of over-engineering dear reader. The LSP servers table
--- can contain a server specified in a bunch of different ways, which is arguably
--- barely more convenient. This function is a helper than then marshals things
--- into the correct shape. All this is more for fun and experimentation with lua
--- than because it's remotely necessary.
---@param name string | number
---@param config table<string, any> | function | string
---@return table<string, any>
function as.lsp.convert_config(name, config)
  if type(name) == 'number' then
    name = config
  end
  local config_type = type(config)
  local data = ({
    ['string'] = function()
      return {}
    end,
    ['boolean'] = function()
      return {}
    end,
    ['table'] = function()
      return config
    end,
    ['function'] = function()
      return config()
    end,
  })[config_type]()
  return name, data
end

---Logic to (re)start installed language servers for use initialising lsps
---and restarting them on installing new ones
---@param config table<string, any>
---@return string, table<string, any>
function as.lsp.get_server_config(config)
  config.on_attach = config.on_attach or as.lsp.on_attach
  config.capabilities = config.capabilities or vim.lsp.protocol.make_client_capabilities()
  local nvim_lsp_ok, cmp_nvim_lsp = as.safe_require('cmp_nvim_lsp')
  if nvim_lsp_ok then
    cmp_nvim_lsp.update_capabilities(config.capabilities)
  end
  return config
end

--- LSP server configs are setup dynamically as they need to be generated during
--- startup so things like the runtimepath for lua is correctly populated
as.lsp.servers = {
  -- 'pyright',
  'julials',
  'sqls',
  'jsonls',
  'bashls',
  'vimls',
  'yamlls',
  pyright = function()
    local pysettings = {
      python = {
        analysis = {
          TypeChecking = 'off',
          UseLibraryCodeTypes = true,
          AutoImportCompletions = true,
          AutoSearchPaths = true,
        },
      },
    }
    return pysettings
  end,
  gopls = false, -- NOTE: this is loaded by it's own plugin
  ---  NOTE: This is the secret sauce that allows reading requires and variables
  --- between different modules in the nvim lua context
  --- @see https://gist.github.com/folke/fe5d28423ea5380929c3f7ce674c41d8
  --- if I ever decide to move away from lua dev then use the above
  sumneko_lua = function()
    local settings = {
      settings = {
        Lua = {
          format = { enable = false },
          diagnostics = {
            globals = { 'vim', 'describe', 'it', 'before_each', 'after_each', 'packer_plugins' },
          },
          completion = { keywordSnippet = 'Replace', callSnippet = 'Replace' },
        },
      },
    }
    local ok, lua_dev = as.safe_require('lua-dev')
    if not ok then
      return settings
    end
    return lua_dev.setup({
      library = { plugins = { 'lua-dev.nvim', 'plenary.nvim' } },
      lspconfig = settings,
    })
  end,
}

return function()
  require('nvim-lsp-installer').setup({
    automatic_installation = true,
  })
  if vim.v.vim_did_enter == 1 then
    return
  end
  for name, config in pairs(as.lsp.servers) do
    name, config = as.lsp.convert_config(name, config)
    if config then
      require('lspconfig')[name].setup(as.lsp.get_server_config(config))
    end
  end
end
-- vim set fdm=marker
