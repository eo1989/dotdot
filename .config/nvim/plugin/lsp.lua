---@diagnostic disable: duplicate-set-field, undefined-field
if not as then return end

local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local fmt = string.format
local diagnostic = vim.diagnostic
-- local L = vim.lsp.log_levels

local icons = as.style.icons.lsp
local border = as.style.current.border

-- local semantic = vim.F.npcall(require, 'nvim-semantic-tokens')

-- if vim.env.DEVELOPING then vim.lsp.set_log_level(L.DEBUG) else vim.lsp.set_log_level(L.OFF) end

-- if vim.fn.has 'nvim-0.7'== 1 then
--   require("vim.lsp.log").set_format_func(vim.pretty_print(vim.inspect))
-- end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

local FEATURES = {
  DIAGNOSTICS = { name = 'diagnostics' },
  CODELENS = { name = 'codelens', provider = 'codeLensProvider' },
  FORMATTING = { name = 'formatting', provider = 'documentFormattingProvider' },
  REFERENCES = { name = 'references', provider = 'documentHighlightProvider' },
  -- SEMANTIC_TOKENS = { name = 'semantictokens', provider = 'semanticTokensProvider' },
}

---@param bufnr integer
---@param capability string
---@return table[]
local function clients_by_capability(bufnr, capability)
  return vim.tbl_filter(
    function(c) return c.server_capabilities[capability] end,
    lsp.get_active_clients({ buffer = bufnr })
  )
end

---@param buf integer
---@return boolean
local function is_buffer_valid(buf)
  return buf and api.nvim_buf_is_loaded(buf) and api.nvim_buf_is_valid(buf)
end

--- Create augroups for each LSP feature and track which capabilities each client
--- registers in a buffer local table
---@param bufnr integer
---@param client table
---@param events table
---@return fun(feature: string, commands: fun(string): Autocommand[])
local function augroup_factory(bufnr, client, events)
  return function(feature, commands)
    local provider, name = feature.provider, feature.name
    if not provider or client.server_capabilities[provider] then
      events[name].group_id = as.augroup(fmt('LspCommands_%d_%s', bufnr, name), commands(provider))
      table.insert(events[name].clients, client.id)
    end
  end
end

local function formatting_filter(client)
  local exceptions = ({
    sql = { 'null-ls' }, -- 'sqls'
    lua = { 'sumneko_lua' },
    proto = { 'null-ls' },
    -- python = { 'pyright','pylsp' }, -- curious if both can be printed and
    -- used
    python = { 'null-ls' },
    -- python = { 'pylsp' },
  })[vim.bo.filetype]

  if not exceptions then return true end
  return not vim.tbl_contains(exceptions, client.name)
end

---@param opts table<string, any>
local function format(opts)
  opts = opts or {}
  vim.lsp.buf.format({
    bufnr = opts.bufnr,
    async = opts.async,
    filter = formatting_filter,
  })
end

-- never request typescript-language-server for formatting EXAMPLE
--[[ vim.lsp.buf.format {
  filter = function(client) return client.name ~= 'tsserver' end
} ]]


--- Autocommands are created per buffer per feature, i.e. if buffer 8 attaches an LSP server
--- then an augroup with the pattern `LspCommands_8_{FEATURE}` will be created. These augroups are
--- localised to a buffer because the features are local to only that buffer and when we detach we need to delete
--- the augroups by buffer so as not to turn off the LSP for other buffers. The commands are also localised
--- to features because each autocommand for a feature e.g. formatting needs to be created in an idempotent
--- fashion because this is called n number of times for each client that attaches.
---
--- So if there are 3 clients and 1 supports formatting and another code lenses, and the last only references.
--- All three features should work and be setup. If only one augroup is used per buffer for all features then each time
--- a client detaches all lsp features will be disabled. Or the augroup will be recreated for the new client but
--- as a client might not support functionality that was already in place, the augroup will be deleted and recreated
--- without the commands for the features that that client does not support.
--- TODO: find a way to make this less complex...
---@param client table<string, any>
---@param bufnr number
local function setup_autocommands(client, bufnr)
  if not client then
    local msg = fmt('Unable to setup LSP autocommands, client for %d is missing', bufnr)
    return vim.notify(msg, 'error', { title = 'LSP Setup' })
  end

  local events = vim.F.if_nil(vim.b.lsp_events, {
    [FEATURES.CODELENS.name] = { clients = {}, group_id = nil },
    [FEATURES.FORMATTING.name] = { clients = {}, group_id = nil },
    [FEATURES.DIAGNOSTICS.name] = { clients = {}, group_id = nil },
    [FEATURES.REFERENCES.name] = { clients = {}, group_id = nil },
    -- [FEATURES.SEMANTIC_TOKENS.name] = { clients = {}, group_id = nil },
  })

  local augroup = augroup_factory(bufnr, client, events)

  -- local caps = client.server_capabilities
  -- augroup(FEATURES.SEMANTIC_TOKENS, function()
  --   return {
  --     {
  --       event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
  --       -- event = { 'TextChanged' },
  --       buffer = bufnr,
  --       desc = 'LSP: Semantic highlights',
  --       command = function()
  --         local caps = client.server_capabilities
  --         -- local semantic = require("as.plugins.nvim-semantic-tokens")
  --         if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
  --           ------------------------------------
  --           local aug = vim.api.nvim_create_augroup( 'BufEnter,CursorHold,InsertLeave' , {})
  --           vim.api.nvim_create_autocmd("TextChanged", {
  --             group = aug,
  --             buffer = bufnr,
  --             callback = function()
  --               vim.lsp.buf.semantic_tokens_full()
  --             end
  --           })
  --           -- clients_by_capability(provider)
  --           vim.lsp.buf.semantic_tokens_full()
  --         -- else
  --         --  require 'vim.lsp.buf.semantic_tokens'.refresh(vim.api.nvim_get_current_buf())
  --         end
  --       end
  --     },
  --   }
  -- end)

  augroup(FEATURES.DIAGNOSTICS, function()
    return {
      {
        event = { 'CursorHold' },
        buffer = bufnr,
        desc = 'LSP: Show diagnostics',
        command = function(args)
          if vim.b.lsp_hover_win and api.nvim_win_is_valid(vim.b.lsp_hover_win) then return end
          vim.diagnostic.open_float(args.buf, { scope = 'cursor', focus = false })
        end,
      },
    }
  end)

  augroup(FEATURES.FORMATTING, function(provider)
    return {
      {
        event = 'BufWritePre',
        buffer = bufnr,
        desc = 'LSP: Format on save',
        command = function(args)
          if not vim.g.formatting_disabled and not vim.b.formatting_disabled then
            local clients = clients_by_capability(args.buf, provider)
            format({ bufnr = args.buf, async = #clients == 1 })
          end
        end,
      },
    }
  end)

  augroup(FEATURES.CODELENS, function()
    return {
      {
        event = { 'BufEnter', 'CursorHold', 'InsertLeave' },
        desc = 'LSP: Code Lens',
        buffer = bufnr,
        command = function()
          lsp.codelens.refresh()
        end,
      },
    }
  end)

  augroup(FEATURES.REFERENCES, function()
    return {
      {
        event = 'CursorHold',
        buffer = bufnr,
        desc = 'LSP: References',
        command = function()
          lsp.buf.document_highlight()
        end,
      },
      {
        event = 'CursorMoved',
        desc = 'LSP: References Clear',
        buffer = bufnr,
        command = function()
          lsp.buf.clear_references()
        end,
      },
    }
  end)
  vim.b[bufnr].lsp_events = events
end

-----------------------------------------------------------------------------//
-- Mappings
-----------------------------------------------------------------------------//

---Setup mapping when an lsp attaches to a buffer
---@param _ table lsp client
---@param bufnr number
local function setup_mappings(_, bufnr)
  local function with_desc(desc)
    return { buffer = bufnr, desc = desc }
  end

  as.nnoremap(']c', function()
    vim.diagnostic.goto_prev({ float = true })
  end, with_desc('lsp: go to prev diagnostic'))

  as.nnoremap('[c', function()
    vim.diagnostic.goto_next({ float = true })
  end, with_desc('lsp: go to next diagnostic'))

  vim.keymap.set({ 'n', 'x' }, '<leader>ca', lsp.buf.code_action, with_desc('lsp: code action'))
  as.nnoremap('<leader>rf', format, with_desc('lsp: format buffer'))
  as.nnoremap('gd', lsp.buf.definition, with_desc('lsp: definition'))
  as.nnoremap('gy', lsp.buf.declaration, with_desc('lsp: declaration'))
  as.nnoremap('gr', lsp.buf.references, with_desc('lsp: references'))
  as.nnoremap('K', lsp.buf.hover, with_desc('lsp: hover'))
  as.nnoremap('g0', lsp.buf.document_symbol, with_desc('lsp: document symbol'))
  -- as.nnoremap('gI', lsp.buf.incoming_calls, with_desc('lsp: incoming calls'))
  as.nnoremap('gI', lsp.buf.implementation, with_desc('lsp: implementation'))
  as.nnoremap('gD', lsp.buf.type_definition, with_desc('lsp: go to type definition'))
  as.nnoremap('<leader>cl', lsp.codelens.run, with_desc('lsp: run code lens'))
  as.nnoremap('<leader>rn', lsp.buf.rename, with_desc('lsp: rename'))
  as.nnoremap('<leader>wa', lsp.buf.add_workspace_folder, with_desc('lsp: add workspace folder'))
  as.nnoremap('<leader>wr', lsp.buf.remove_workspace_folder, with_desc('lsp: remove workspace folder'))
  as.nnoremap('<leader>wl', function() vim.pretty_print(lsp.buf.list_workspace_folders()) end, with_desc('lsp: list workspace folders'))
end

-----------------------------------------------------------------------------//
-- LSP SETUP/TEARDOWN
-----------------------------------------------------------------------------//

---@param client table
---@param bufnr number
local function setup_plugins(client, bufnr)

  local navic_ok, navic = pcall(require, 'nvim-navic')
  if navic_ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  local hints_ok, hints = pcall(require, 'lsp-inlayhints')
  if hints_ok then hints.on_attach(client, bufnr) end

  -- local caps = client.server_capabilities
  -- local semantics_mmk, semantics = pcall(require, 'nvim-semantic-tokens')
  -- local semantics_mmk, semantics = pcall(require, 'as.plugins.semantictokens')
  -- if semantics_mmk then
  --   if caps.semanticTokensProvider and caps.semanticTokensProvider.full then
  --     local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
  --     vim.api.nvim_create_autocmd("TextChanged", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         vim.lsp.buf.semantic_tokens_full()
  --       end,
  --     })
  --     -- fire it first time on load as well
  --     vim.lsp.buf.semantic_tokens_full()
  --   end
  -- end
end

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
---@param client table the lsp client
---@param bufnr number
local function on_attach(client, bufnr)
  setup_plugins(client, bufnr)
  setup_autocommands(client, bufnr)
  setup_mappings(client, bufnr)
end

--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic in the general on_attach function
local client_overrides = {
  sqls = function(client, bufnr)
    require('sqls').on_attach(client, bufnr)
  end,
  -- pylance = function(client, bufnr)
  -- --  require('as.pylance_').on_attach(client, bufnr)
  --  require('as.custom_py.pylance').on_attach(client, bufnr)
  -- end
}

as.augroup('LspSetupCommands', {
  {
    event = 'LspAttach',
    desc = 'setup the language server autocommands',
    command = function(args)
      local bufnr = args.buf
      -- if the buffer is invalid we should not try and attach to it
      if not api.nvim_buf_is_valid(bufnr) or not args.data then return end
      local client = lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
      if client_overrides[client.name] then
        client_overrides[client.name](client, bufnr)
      end
    end,
  },
  {
    event = 'LspDetach',
    desc = 'Clean up after detached LSP',
    command = function(args)
      local client_id = args.data.client_id
      if not vim.b.lsp_events or not client_id then
        return
      end
      for _, state in pairs(vim.b.lsp_events) do
        if #state.clients == 1 and state.clients[1] == client_id then
          api.nvim_clear_autocmds({ group = state.group_id, buffer = args.buf })
        end
        vim.tbl_filter(function(id)
          return id ~= client_id
        end, state.clients)
      end
    end,
  },
      -------------------------------------------------------- eo
  -- {
  --   event = 'LspProgressUpdate',
  --   desc = 'Receipt of progress notifications from LSP',
  --   command = function()
  --     if vim.lsp.util.get_progress_messages() == 1 then
  --       vim.cmd [[redrawstatus]]
  --     end
  --   end
  -- },
})
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
local command = as.command

command('LspFormat', function()
  -- Note: setting async = true means the method wont block, default is false.
  -- 'Editing the buffer while formatting asynchronously can lead to unexpected
  -- changes.'
  format({ bufnr = 0, async = false })
end)

do
  ---@type integer?
  local id
  local TITLE = 'DIAGNOSTICS'
  -- A helper function to auto-update the quickfix list when new diagnostics come
  -- in and close it once everything is resolved. This functionality only runs whilst
  -- the list is open.
  -- similar functionality is provided by: https://github.com/onsails/diaglist.nvim
  local function smart_quickfix_diagnostics()
    if not is_buffer_valid(api.nvim_get_current_buf()) then
      return
    end

    diagnostic.setqflist({ open = false, title = TITLE })
    as.toggle_qf_list()

    if not as.is_vim_list_open() and id then
      api.nvim_del_autocmd(id)
      id = nil
    end

    id = id
      or api.nvim_create_autocmd('DiagnosticChanged', {
        callback = function()
          -- skip QF lists that we did not populate
          if not as.is_vim_list_open() or fn.getqflist({ title = 0 }).title ~= TITLE then
            return
          end
          diagnostic.setqflist({ open = false, title = TITLE })
          if #fn.getqflist() == 0 then
            as.toggle_qf_list()
          end
        end,
      })
  end
  command('LspDiagnostics', smart_quickfix_diagnostics)
  as.nnoremap('<leader>ll', '<Cmd>LspDiagnostics<CR>', 'toggle quickfix diagnostics')
end

-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
local function sign(opts)
  fn.sign_define(opts.highlight, {
    text = opts.icon,
    texthl = opts.highlight,
    numhl = opts.highlight .. 'Nr',
    culhl = opts.highlight .. 'CursorNr',
    linehl = opts.highlight .. 'Line',
  })
end

sign({ highlight = 'DiagnosticSignError', icon = icons.error })
sign({ highlight = 'DiagnosticSignWarn', icon = icons.warn })
sign({ highlight = 'DiagnosticSignInfo', icon = icons.info })
sign({ highlight = 'DiagnosticSignHint', icon = icons.hint })
-----------------------------------------------------------------------------//
-- Handler Overrides
-----------------------------------------------------------------------------//
--[[
This section overrides the default diagnostic handlers for signs and virtual text so that only
the most severe diagnostic is shown per line
--]]

local ns = api.nvim_create_namespace('severe-diagnostics')

--- Restricts nvim's diagnostic signs to only the single most severe one per line
---see  ":help vim.diagnostic"
local function max_diagnostic(callback)
  return function(_, bufnr, _, opts)
    -- Get all diagnostics from the whole buffer rather than just the
    -- diagnostics passed to the handler
    local diagnostics = vim.diagnostic.get(bufnr)
    -- Find the "worst" diagnostic per line
    local max_severity_per_line = {}
    for _, d in pairs(diagnostics) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then
        max_severity_per_line[d.lnum] = d
      end
    end
    -- Pass the filtered diagnostics (with our custom namespace) to
    -- the original handler
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local signs_handler = diagnostic.handlers.signs
diagnostic.handlers.signs = vim.tbl_extend('force', signs_handler, {
  show = max_diagnostic(signs_handler.show),
  hide = function(_, bufnr)
    signs_handler.hide(ns, bufnr)
  end,
})

local virt_text_handler = diagnostic.handlers.virtual_text
diagnostic.handlers.virtual_text = vim.tbl_extend('force', virt_text_handler, {
  show = max_diagnostic(virt_text_handler.show),
  hide = function(_, bufnr)
    virt_text_handler.hide(ns, bufnr)
  end,
})

-----------------------------------------------------------------------------//
-- Diagnostic Configuration
-----------------------------------------------------------------------------//
local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

--- Save options for virtual text for future use
---@diagnostic disable-next-line: unused-local
local virtual_text_opts = {
  spacing = 4,
  prefix = '',
  format = function(d)
    local level = diagnostic.severity[d.severity]
    return fmt('%s %s', icons[level:lower()], d.message)
  end,
}

diagnostic.config({
  signs = true,
  underline = true, --
  update_in_insert = false,
  severity_sort = true,
  virtual_text = false,
  float = {
    max_width = max_width,
    max_height = max_height,
    border = border,
    focusable = false,
    source = 'if_many', -- 'if_many', 'always'
    prefix = function(diag, i, _)
      local level = diagnostic.severity[diag.severity]
      local prefix = fmt('%d. %s ', i, icons[level:lower()])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
  },
})

-- lsp.handlers['textDocument/hover'] =
--   lsp.with(lsp.handlers.hover, { border = border, max_width = max_width, max_height = max_height })
-- lsp.handlers['textDocument/definition'] = function (_, result)
--   if not result or vim.tbl_isempty(result) then
--     print("[LSP] Could not find definition")
--     return
--   end
--
--   if vim.tbl_islist(result) then
--     vim.lsp.util.jump_to_location(result[1], "utf-8")
--   else
--     vim.lsp.util.jump_to_location(result, "utf-8")
--   end
-- end


-- lsp.handlers['textDocument/hover'] = function(...)
--   local hover_handler = lsp.with(lsp.handlers.hover, {
--     border = border,
--     max_width = max_width,
--     max_height = max_height,
--     stylize_markdown = true,
--     syntax = "lsp_markdown"
--   })
--   vim.b.lsp_hover_buf, vim.b.lsp_hover_win = hover_handler(...)
-- end

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
  stylize_markdown = true,
  syntax = "lsp_markdown",
  border = "single",
})

lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, {
  border = border,
  max_width = max_width,
  max_height = max_height,
})

lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, lvl, {
    title = 'LSP | ' .. client.name,
    timeout = 2000,
    keep = function()
      return lvl == 'ERROR' or lvl == 'WARN'
    end,
  })
end
--vim:ft=lua sts=2 ts=2 sw=2 nospell:
