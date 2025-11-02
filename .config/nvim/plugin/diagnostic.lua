---@diagnostic disable: param-type-mismatch, undefined-doc-name, undefined-field, unused-function, undefined-doc-name, undefined-field, param-type-mismatch
if not eo and eo.KITTY_SCROLLBACK then return end

local lsp, fs, fn, api, fmt = vim.lsp, vim.fs, vim.fn, vim.api, string.format
local diagnostic = vim.diagnostic
local L, S = vim.lsp.log_levels, diagnostic.severity
local M = vim.lsp.protocol.Methods

-- local unpack = unpack or table.unpack
-- local border = eo.ui.current.border

local icons = eo.ui.icons.lsp
local augroup = eo.augroup

----------------------------------------------------------------------------------------------------
--  LSP file Rename
----------------------------------------------------------------------------------------------------

-- ---@param data { old_name: string, new_name: string }
-- local function prepare_rename(data)
--   local bufnr = fn.bufnr(data.old_name)
--   for _, client in pairs(lsp.get_clients { bufnr = bufnr }) do
--     local rename_path = { 'server_capabilities', 'workspace', 'fileOperations', 'willRename' }
--     if not vim.tbl_get(client, rename_path) then
--       return vim.notify(fmt('%s does not LSP file rename', client.name), 'info', { title = 'LSP' })
--     end
--     local params = {
--       files = { { newUri = 'file://' .. data.new_name, oldUri = 'file://' .. data.old_name } },
--     }
--     ---@diagnostic disable-next-line: invisible
--     local resp = client.request_sync('workspace/willRenameFiles', params, 1000)
--     if resp then vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding) end
--   end
-- end

-- local function rename_file()
--   vim.ui.input({ prompt = 'New name: ' }, function(name)
--     if not name then return end
--     local old_name = api.nvim_buf_get_name(0)
--     local new_name = fmt('%s/%s', fs.dirname(old_name), name)
--     prepare_rename { old_name = old_name, new_name = new_name }
--     lsp.util.rename(old_name, new_name)
--   end)
-- end

----------------------------------------------------------------------------------------------------
--  Related Locations
----------------------------------------------------------------------------------------------------
-- This relates to:
-- 1. https://github.com/neovim/neovim/issues/19649#issuecomment-1327287313
-- 2. https://github.com/neovim/neovim/issues/22744#issuecomment-1479366923
-- neovim does not currently correctly report the related locations for diagnostics.
-- TODO: once a PR for this is merged delete this workaround

local function show_related_locations(diag)
  local related_info = diag.relatedInformation
  if not related_info or #related_info == 0 then return diag end
  for _, info in ipairs(related_info) do
    diag.message = ('%s\n%s(%d:%d)%s'):format(
      diag.message,
      fn.fnamemodify(vim.uri_to_fname(info.location.uri), ':p:.'),
      info.location.range.start.line + 1,
      info.location.range.start.character + 1,
      not eo.falsy(info.message) and (': %s'):format(info.message) or ''
    )
  end
  return diag
end

local handler = lsp.handlers[M.textDocument_publishDiagnostics]
---@diagnostic disable-next-line: duplicate-set-field
lsp.handlers[M.textDocument_publishDiagnostics] = function(err, result, ctx)
  result.diagnostics = vim.tbl_map(show_related_locations, result.diagnostics)
  handler(err, result, ctx)
end

--[[
-- from dhruvmanila's dotfiles:
-- https://github.com/dhruvmanila/dotfiles/blob/master/config/nvim/plugin/lsp/attach.lua
--]]

---@param client lsp.Client
-- local function create_on_list(client)
--   ---@param opts vim.lsp.LocationOpts.OnList
--   return function(opts)
--     -- the `user_data` field contains the original location data from the server.
--     lsp.util.show_document(opts.items[1].user_data, client.offset_encoding, {
--       focus = true,
--       reuse_win = false,
--     })
--     if vim.tbl_count(opts.items) > 1 then
--       ---@diagnostic disable-next-line: param-type-mismatch
--       fn.setqflist({}, ' ', opts)
--       api.nvim_command('copen | wincmd p')
--     end
--     eo.center_cursor()
--   end
-- end

-- lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'rounded' })
-- lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, { border = border })

-- lsp.handlers['textDocument/hover'] = function(err, res, ctx, _)
--   local _, winid = lsp.handlers.hover(err, res, ctx, {
--     -- border = 'rounded',
--     border = 'shadow',
--     silent = true, -- disable 'No information available' notification
--   })
--   api.nvim_set_option_value('conceallevel', 3, {
--     scope = 'local',
--     win = winid,
--   })
-- end

lsp.handlers['window/logMessage'] = function(_, content, _)
  if content.type == 3 then
    if content.message:find('pythonPath') then vim.notify(content.message) end
  end
end

-- Mappings
--Setup mapping when an lsp attaches to a buffer
-- ---@param client vim.lsp.Client
-- ---@param bufnr integer
-- local function setup_mappings(client, bufnr)
--   map('n', '<leader>dt', function() diagnostic.enable(not diagnostic.is_enabled()) end, { desc = 'Toggle diagnostics' })
--
--   map('n', '[d', function()
--     if diagnostic.jump { count = vim.v.count1 } then eo.center_cursor() end
--   end, { desc = 'Diag: goto next' })
--
--   map('n', ']d', function()
--     if diagnostic.jump { count = -vim.v.count1 } then eo.center_cursor() end
--   end, { desc = 'Diag: goto prev ' })
--
--   if client:supports_method(M.textDocument_codeAction) then
--     map({ 'n', 'x' }, '<leader>ca', lsp.buf.code_action, { buffer = bufnr, desc = 'Lsp: [c]ode [a]ction' })
--   end
--
--   if client:supports_method(M.textDocument_codeLens) then
--     map({ 'n', 'x' }, '<leader>cl', lsp.codelens.run, { buffer = bufnr, desc = 'Lsp: [c]ode [l]ens' })
--   end
--
--   if client:supports_method(M.textDocument_typeDefinition) then
--     -- map('n', '<leader>gd', lsp.buf.type_definition, { buffer = bufnr, desc = 'lsp: type defs' })
--     -- map('n', '<leader>gd', [[:Glance type_definitions<CR>]], { buffer = bufnr, desc = 'Glance: type defs' })
--     map('n', 'gy', [[:Glance type_definitions<CR>]], { buffer = bufnr, desc = 'Glance: t[y]pe defs' })
--   end
--
--   if client:supports_method(M.textDocument_definition) then
--     -- if not vim.tbl_contains({ 'typescript', 'typescriptreact' }, vim.bo[bufnr].ft) then
--     -- if not ok then
--     -- map('n', 'gd', fzflua_lsp.lsp_definitions, { buffer = bufnr, desc = 'fzf lsp: definition' })
--     -- map('n', '<leader>gd', [[:FzfLua lsp_typedefs<CR>]], { buffer = bufnr, desc = 'fzf lsp: definition' })
--     -- else
--     -- end
--     -- map('n', 'gd', lsp.buf.definition, { buffer = bufnr, desc = 'lsp: definition' })
--     map('n', 'gd', [[:Glance definitions<CR>]], { buffer = bufnr, desc = 'Glance: defs' })
--     -- end
--     -- map('n', 'gd', lsp.buf.definition, { buffer = bufnr, desc = 'lsp: def' })
--     -- map('n', 'gd', [[:FzfLua lsp_definitions<CR>]], { buffer = bufnr, desc = 'fzf lsp: definition' })
--   end
--
--   -- if client:supports_method(M.textDocument_declaration) then
--   --   map(
--   --     'n',
--   --     'gD',
--   --     lsp.buf.declaration { on_list = create_on_list(client) },
--   --     { buffer = bufnr, desc = 'Lsp: [g]oto [D]eclarations' }
--   --   )
--   -- end
--
--   if client:supports_method(M.textDocument_references) then
--     -- map('n', 'gr', lsp.buf.references, { buffer = bufnr, desc = 'lsp: refs' })
--     map('n', 'gr', [[:Glance references<CR>]], { buffer = bufnr, desc = 'Lsp: [g]oto [r]references' })
--     -- map('n', 'gr', [[:FzfLua lsp_references<CR>]], { buffer = bufnr, desc = 'lsp: references' })
--   end
--
--   if client:supports_method(M.textDocument_implementation) then
--     -- map('n', 'gi', lsp.buf.implementation, { buffer = bufnr, desc = 'Lsp: [g]oto [i]mplementation' })
--     map('n', 'gi', [[:Glance implementations<CR>]], { buffer = bufnr, desc = 'lsp: implementation' })
--     -- map('n', 'gi', [[:FzfLua lsp_implementations profile=ivy<CR>]], { buffer = bufnr, desc = 'lsp: implementation' })
--   end
--
--   if client:supports_method(M.textDocument_hover) then
--     map('n', 'K', function() lsp.buf.hover { border = border } end, { buffer = bufnr, desc = 'Lsp: hover' })
--   end
--
--   -- if client:supports_method(M.textDocument_prepareCallHierarchy) then
--   --   -- map('n', 'gI', [[:FzfLua lsp_incoming_calls profile='ivy'<CR>]], { buffer = bufnr, desc = 'lsp: incoming calls' })
--   --   map('n', 'gI', lsp.buf.incoming_calls, { buffer = bufnr, desc = 'Lsp: incoming calls' })
--   -- end
--
--   if client:supports_method(M.textDocument_rename) then
--     map('n', '<leader>rn', lsp.buf.rename, { buffer = bufnr, desc = 'lsp: rename' })
--     -- map('n', '<leader>rN', rename_file, { buffer = bufnr, desc = 'lsp: rename file' })
--   end
--
--   if vim.lsp['inlay_hint'] ~= nil and client:supports_method(M.textDocument_inlayHint) then
--     --[[ Should check if this nvim version supports inlay hints, enable them ]]
--     map('n', '<leader>ci', function() lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled()) end, {
--       buffer = bufnr,
--       desc = 'lsp: inlay hints toggle',
--     })
--   end
-- end

-----------------------------------------------------------------------------//
-- LSP SETUP/TEARDOWN
-----------------------------------------------------------------------------//

---@alias ClientOverrides {on_attach: fun(client: vim.lsp.Client, bufnr: number), semantic_tokens: fun(bufnr: number, client: vim.lsp.Client, token: table)}

--- A set of custom overrides for specific lsp clients
--- This is a way of adding functionality for specific lsps
--- without putting all this logic inthe general on_attach function
---@type {[string]: ClientOverrides}
-- local client_overrides = {
--   tsserver = {
--     semantic_tokens = function(bufnr, client, token)
--       if token.type == 'variable' and token.modifiers['local'] and not token.modifiers.readonly then
--         lsp.semantic_tokens.highlight_token(token, bufnr, client.id, '@danger')
--       end
--     end,
--   },
-- }

-----------------------------------------------------------------------------//
-- Semantic Tokens
-----------------------------------------------------------------------------//

---@param client vim.lsp.Client
---@param bufnr number
-- local function setup_semantic_tokens(client, bufnr)
--   local overrides = client_overrides[client.name]
--   if not overrides or not overrides.semantic_tokens then return end
--   augroup(fmt('LspSemanticTokens%s', client.name), {
--     event = 'LspTokenUpdate',
--     buffer = bufnr,
--     desc = fmt('Configure the semantic tokens for the %s', client.name),
--     command = function(args) overrides.semantic_tokens(args.buf, client, args.data.token) end,
--   })
-- end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

---@param client lsp.Client
---@param buf integer
-- local function setup_autocommands(client, buf)
--   if client:supports_method(M.textDocument_codeLens) then
--     augroup(('LspCodeLens%d'):format(buf), {
--       event = { 'BufEnter', 'InsertLeave', 'BufWritePost' },
--       desc = 'LSP: Code Lens',
--       buffer = buf,
--       -- call via vimscript so that errors are silenced
--       command = 'silent! lua vim.lsp.codelens.refresh()',
--     })
--   end
--
--   if client:supports_method(M.textDocument_inlayHint, { bufnr }) then
--     vim.lsp.inlay_hint.enable(true, { bufnr = buf })
--   end
--
--   local folding_exclusions = { 'lua_ls' }
--   if client:supports_method('textDocument/foldingRange') and vim.tbl_contains(folding_exclusions, client.name) then
--     -- local win = vim.api.nvim_set_current_win()
--     -- vim.wo[win][0].foldmethod = 'expr'
--     -- vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
--     --[[ akinsho below, lspconfig foldexpr example above ]]
--     vim.wo.foldmethod = 'expr'
--     -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--     -- augroup(('LspFold%d'):format(buf), {
--     --   event = { 'BufEnter' },
--     --   buffer = buf,
--     --   command = function(args)
--     --     local client = lsp.get_client_by_id(args.data.client_id)
--     --     if client:supports_method('textDocument/foldingRange') then
--     --       local win = api.nvim_get_current_win()
--     --       vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
--     --     end
--     --   end,
--     -- })
--
--     vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
--   end
--
--   if client:supports_method('textDocument_hover') and vim.tbl_contains({ 'ruff' }, client.name) then
--     client.server_capabilities.hoverProvider = false
--   end
--
--   local format_exclusions = { 'lua_ls', 'ruff', 'basedpyright', 'julials', 'sith_language_server', 'bashls', 'taplo' }
--   if
--     client:supports_method(M.textDocument_formatting, { bufnr }) and vim.tbl_contains(format_exclusions, client.name)
--   then
--     client.server_capabilities.documentFormattingProvider = false
--     client.server_capabilities.documentRangeFormattingProvider = false
--   end
--
--   if client:supports_method(M.textDocument_inlayHint, { bufnr = buf }) then vim.lsp.inlay_hint.enable(true) end
--
--   -- if client:supports_method(M.textDocument_documentSymbol, { bufnr = buf })  then
--   --   require('nvim-navic').attach(client, bufnr)
--   -- end
--
--   if client:supports_method(M.textDocument_documentHighlight) then
--     augroup(('LspReferences%d'):format(buf), {
--       event = { 'CursorHold', 'CursorHoldI' },
--       buffer = buf,
--       desc = 'LSP: References',
--       command = function() lsp.buf.document_highlight() end,
--     }, {
--       event = 'CursorMoved',
--       desc = 'LSP: References Clear',
--       buffer = buf,
--       command = function() lsp.buf.clear_references() end,
--     })
--   end
-- end

-- Add buffer local mappings, autocommands etc for attaching servers
-- this runs for each client because they have different capabilities so each time one
-- attaches it might enable autocommands or mappings that the previous client did not support
---@param client lsp.Client the lsp client
---@param bufnr number
-- local function on_attach(client, bufnr)
--   -- setup_autocommands(client, bufnr)
--   -- setup_mappings(client, bufnr)
--   setup_semantic_tokens(client, bufnr)
-- end

-- augroup(
--   'LspSetupCommands',
--   -- {
--   --   event = 'LspAttach',
--   --   desc = 'setup the lsp autocommands',
--   --   command = function(args)
--   --     local client = lsp.get_client_by_id(args.data.client_id)
--   --     if not client then return end
--   --     on_attach(client, args.buf)
--   --     local overrides = client_overrides[client.name]
--   --     if not overrides or not overrides.on_attach then return end
--   --     overrides.on_attach(client, args.buf)
--   --   end,
--   -- },
--   {
--     event = 'DiagnosticChanged',
--     desc = 'Update the diagnostic locations',
--     command = function(args)
--       diagnostic.setloclist { open = false }
--       if #args.data.diagnostics == 0 then vim.cmd('silent! lclose') end
--     end,
--   }
-- )

-----------------------------------------------------------------------------//
-- Handler Overrides
-----------------------------------------------------------------------------//
-- This section overrides the default diagnostic handlers for signs and virtual text so that only
-- the most severe diagnostic is shown per line

--- The custom namespace is so that ALL diagnostics across all namespaces can be aggregated
--- including diagnostics from plugins
local ns = api.nvim_create_namespace('severe-diagnostics')

--- Restricts nvim's diagnostic signs to only the single most severe one per line
--- see `:help vim.diagnostic`
--[[---@param callback fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)]]
--[[---@return fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)]]
-- local function max_diagnostic(callback)
--   return function(_, bufnr, diagnostics, opts)
--     local max_severity_per_line = vim.iter(diagnostics):fold({}, function(diag_map, d)
--       local m = diag_map[d.lnum]
--       if not m or d.severity < m.severity then diag_map[d.lnum] = d end
--       return diag_map
--     end)
--     callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
--   end
-- end

local signs_handler = diagnostic.handlers.signs

-- diagnostic.handlers.signs = vim.tbl_extend('force', signs_handler, {
--   show = max_diagnostic(signs_handler.show),
--   hide = function(_, bufnr) signs_handler.hide(ns, bufnr) end,
-- })

diagnostic.handlers.signs = {
  show = function(_, bufnr, _, opts)
    local diags = diagnostic.get(bufnr)

    local max_severity_per_line = {}
    for _, d in pairs(diags) do
      local m = max_severity_per_line[d.lnum]
      if not m or d.severity < m.severity then max_severity_per_line[d.lnum] = d end
    end

    local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
    signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
  end,
  hide = function(_, bufnr) signs_handler.hide(ns, bufnr) end,
}

-----------------------------------------------------------------------------//
-- Diagnostic Configuration
-----------------------------------------------------------------------------//

local max_width = math.min(math.floor(vim.o.columns * 0.7), 100)
local max_height = math.min(math.floor(vim.o.lines * 0.3), 30)

-----------------------------------------------------------------------------//
-- Signs
-----------------------------------------------------------------------------//
diagnostic.config {
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  jump = {
    severity = { min = S.WARN, max = S.ERROR },
    -- wrap = true,
    -- float = {
    --   -- focus_id = false,
    --   scope = 'line',
    --   -- namespace = 0,
    -- },
  },
  signs = {
    severity = { min = S.WARN },
    text = {
      [S.WARN] = icons.warn,
      [S.INFO] = icons.info,
      [S.HINT] = icons.hint,
      [S.ERROR] = icons.error,
    },
    -- linehl = {
    --   [S.WARN] = 'DiagnosticSignWarnLine',
    --   [S.INFO] = 'DiagnosticSignInfoLine',
    --   [S.HINT] = 'DiagnosticSignHintLine',
    --   [S.ERROR] = 'DiagnosticSignErrorLine',
    -- },
  },
  virtual_text = false and {
    severity = { min = S.WARN },
    -- severity = { min = diagnostic.severity.WARN },
    spacing = 6,
    prefix = function(d)
      -- local level = diagnostic.severity[d.severity]
      local level = S[d.severity]
      return icons[level:lower()]
    end,
    -- suffix = function(diag)
    --   if not diag then return '' end
    --   local codeOrSource = (tostring(diag.code or diag.source or ''))
    --   if codeOrSource == '' then return '' end
    --   return (' [%s]'):format(codeOrSource:gsub('%.$', ''))
    -- end,
  },
  float = {
    -- namespace = 0,
    max_width = max_width,
    max_height = max_height,
    border = 'rounded',
    title = { { '  ', 'DiagnosticFloatTitleIcon' }, { 'Problems ', 'DiagnosticFloatTitle' } },
    focusable = false, -- no need to enter these windows
    header = '',
    scope = 'line', -- to keep inline with diagflow.nvim
    -- source = 'if_many',
    prefix = function(diag)
      local level = S[diag.severity]
      local prefix = fmt('%s ', icons[level:lower()])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
    ---[[ www.github.com/willothy/nvim-config/blob/main/lua/configs/lsp/lspconfig.lua ]]
    source = 'if_many',
    -- header = setmetatable({}, {
    --   __index = function(_, k)
    --     local arr = {
    --       fmt(
    --         'Diagnostics: %s %s',
    --         require('nvim-web-devicons').get_icon_by_filetype(vim.bo.filetype),
    --         vim.bo.filetype
    --       ),
    --       'Title',
    --     }
    --     return arr[k]
    --   end,
    -- }),
  },
}
