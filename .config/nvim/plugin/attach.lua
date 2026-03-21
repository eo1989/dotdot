if not eo and vim.g.vscode then return end

local api, lsp, fn, fs, fmt = vim.api, vim.lsp, vim.fn, vim.fs, string.format

local diagnostic = vim.diagnostic

local L, M, S = lsp.log_levels, lsp.protocol.Methods, diagnostic.severity

local extensions = require('eo.lsp.extensions')
-- local border = eo.ui.current.border or 'rounded'
local border = require('defaults').ui.border.name or 'rounded'

local lsp_icons = eo.ui.icons.lsp

-- local map = vim.keymap
-- map.del('n', 'grt')
-- map.del('n', 'gri')
-- map.del('n', 'grr')
-- map.del('n', 'grn')
-- map.del({ 'n', 'x' }, 'gra')
-- map.del('n', 'gO')
-- map.del('n', ']b')
-- map.del('n', '[b')
-- map.del('n', ']B')
-- map.del('n', '[B')
-- map.del('n', ']l')
-- map.del('n', '[l')
-- map.del('n', ']L')
-- map.del('n', '[L')
-- map.del('n', ']q')
-- map.del('n', '[q')
-- map.del('n', ']Q')
-- map.del('n', '[Q')

-- Set the default options for all LSP floating windows.
--   - Default border according to `dm.config.border_style`
--   - Limit width and height of the window
--[[ doesnt NOICE HANDLE THIS?? ]]
-- do
--   local default_open_floating_preview = lsp.util.open_floating_preview
--   ---@diagnostic disable-next-line: duplicate-set-field
--   lsp.util.open_floating_preview = function(contents, syntax, opts)
--     opts = vim.tbl_deep_extend('force', opts, {
--       -- border = border,
--       border = 'rounded' or border,
--       max_width = math.min(math.floor(vim.o.columns * 0.7), 120),
--       max_height = math.min(math.floor(vim.o.lines * 0.3), 40),
--     })
--     local bufnr, winnr = default_open_floating_preview(contents, syntax, opts)
--     -- as per `:h 'showbreak'`, the value should be a literal "NONE".
--     vim.wo[winnr].showbreak = 'NONE'
--     return burnr, winnr
--   end
-- end

api.nvim_create_autocmd('LspAttach', {
  group = api.nvim_create_augroup('eo.lsp', { clear = true }),
  -- group = api.nvim_create_augroup('eo.lsp', {}),
  desc = 'LSP Actions',
  callback = function(event)
    -- local bufnr = event.buf ---@type integer

    -- This function resolves a difference between nvim nightly (>=0.11) and stable (0.10)
    ---]]@param client vim.lsp.Client
    ---]]@param method vim.lsp.protocol.Method
    ---]]@param bufnr? integer  -- some lsp support methods only in specific files
    ---]]@return boolean
    -- local function client_supports_method(client, method, bufnr) return client:supports_method(method, bufnr) end

    local client = lsp.get_client_by_id(event.data.client_id) --[[@as vim.lsp.Client]]

    local client_extension = extensions[client.name]
    if client_extension ~= nil then client_extension.on_attach { client, bufnr = event.buf } end

    if vim.bo.filetype == 'lua' then vim.bo[event.buf].formatexpr = nil end
    -- vim.bo[event.buf].formatexpr = nil
    vim.bo[event.buf].omnifunc = nil

    --[[
    -- from:
    -- https://github.com/igorlfs/dotfiles/blob/db4da3f2817a07a32d0013cd7b98c61e9c535c93/nvim/.config/nvim/lua/autocmds/lsp.lua#L14
    -- https://github.com/igorlfs/dotfiles/blob/main/nvim/.config/nvim/lua/autocmds/lsp.lua#L14
    --]]

    -- assert(client ~= nil, 'Has LSP Client')

    lsp.linked_editing_range.enable(true, nil)
    lsp.inline_completion.enable(not lsp.inline_completion.is_enabled())

    if client:supports_method('textDocument/completion') then
      lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end

    -- if client:supports_method(M.textdocument_foldingRange) then
    -- if client:supports_method('textDocument/foldingRange') then
    --   local win = api.nvim_get_current_win()
    --   vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    -- end

    -- if client:supports_method(M.textDocument_documntHighlight) then
    if client:supports_method('textDocument/documentHighlight') then
      local highlight_augroup = api.nvim_create_augroup('eo.highlight', { clear = false })

      api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = highlight_augroup,
        buffer = event.buf,
        callback = lsp.buf.document_highlight,
      })

      api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'TextChangedI' }, {
        group = highlight_augroup,
        buffer = event.buf,
        callback = lsp.buf.clear_references,
      })

      api.nvim_create_autocmd('LspDetach', {
        group = api.nvim_create_augroup('eo.lsp', { clear = true }),
        buffer = event.buf,
        callback = function(ev)
          lsp.buf.clear_references()
          api.nvim_clear_autocmds { group = 'eo.lsp', buffer = ev.buf }
        end,
      })
    end

    -- if client:supports_method(M.textDocument_codeLens) then
    if client:supports_method('textDocument/codeLens') then
      local codeLens_augroup = api.nvim_create_augroup('eo.lsp.codelens', { clear = false })
      api.nvim_clear_autocmds { buffer = buf, group = codeLens_augroup }
      -- api.nvim_create_autocmd({ 'CursorHold', 'TextChanged', 'InsertLeave', 'LspAttach', 'BufEnter' }, {
      api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'LspAttach', 'BufReadPost' }, {
        group = codeLens_augroup,
        buffer = event.buf,
        callback = function() lsp.codelens.enable(true, { bufnr = event.buf }) end,
        desc = 'lsp: refresh codelens',
      })
    end

    ---@param key string|table
    ---@param desc string
    ---@param func function|string
    ---@param mode? string|table
    ---@return nil
    local _map = function(keys, desc, func, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
    end

    --[[
    -- from dhruvmanila's dotfiles:
    -- https://github.com/dhruvmanila/dotfiles/blob/master/config/nvim/plugin/lsp/attach.lua
    --]]

    -- local function on_list(options)
    --   fn.setqflist({}, ' ', options)
    --   vim.cmd.cfirst()
    -- end

    _map('gi', '[g]oto [i]mplementation', function()
      local ok, glance = pcall(require, 'glance')
      if ok then
        glance.open('implementations')
      else
        lsp.buf.implementation()
      end
    end)

    _map('gd', '[g]oto [d]efinition', function()
      local ok, glance = pcall(require, 'glance')
      if ok then
        glance.open('definitions')
      else
        lsp.buf.definition()
      end
    end)

    _map('gD', '[g]oto type [D]ef', function()
      local ok, glance = pcall(require, 'glance')
      if ok then
        glance.open('type_definitions')
      else
        lsp.buf.type_definition(nil, { loclist = false })
      end
    end)

    _map('gr', '[g]oto [r]references', function()
      local ok, glance = pcall(require, 'glance')
      if not ok then
        vim.lsp.buf.references()
      else
        glance.open('references')
      end
      -- if ok then
      --   glance.open('references')
      -- else
      --   vim.lsp.buf.references()
      -- end
    end)

    _map('[d', 'Diag: goto prev', function() vim.diagnostic.jump { count = 1 } end)
    -- _map('[d', 'Diag: goto prev', function() vim.diagnostic.jump { count = 1 } end)

    _map(']d', 'Diag: goto next', function() vim.diagnostic.jump { count = -1 } end)

    _map('<leader>rn', '[r]e[n]ame all symbol references', function() lsp.buf.rename() end)

    _map('<leader>ca', 'select [c]ode [a]ction', function() lsp.buf.code_action() end, { 'n' })

    _map('<leader>cl', 'run [c]ode [l]ens', function() lsp.codelens.run() end)

    _map('<leader>ch', '[c]hange inlay [h]int', function()
      local is_enabled = lsp.inlay_hint.is_enabled { bufnr = event.buf }
      lsp.inlay_hint.enable(not is_enabled, { bufnr = event.buf })
    end)
  end,
})

-- vim.cmd [[
--   autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
--   autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
--   autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
-- ]]

api.nvim_create_autocmd('LspNotify', {
  callback = function(args)
    if args.data.method == 'textDocument/didOpen' then lsp.foldclose('imports', fn.bufwinid(args.buf)) end
  end,
})

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
---@param callback fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
---@return fun(namespace: integer, bufnr: integer, diagnostics: table, opts: table)
local function max_diagnostic(callback)
  return function(_, bufnr, diagnostics, opts)
    local max_severity_per_line = vim.iter(diagnostics):fold({}, function(diag_map, d)
      local m = diag_map[d.lnum]
      if not m or d.severity < m.severity then diag_map[d.lnum] = d end
      return diag_map
    end)
    callback(ns, bufnr, vim.tbl_values(max_severity_per_line), opts)
  end
end

local signs_handler = diagnostic.handlers.signs

diagnostic.handlers.signs = vim.tbl_extend('force', signs_handler, {
  show = max_diagnostic(signs_handler.show),
  hide = function(_, bufnr) signs_handler.hide(ns, bufnr) end,
})

-- Custom handler for requests that returns a list of locations (e.g. definition, references).
--
-- This handler will go to the first location unconditionally and open the quickfix list if there
-- are more than one locations.
---@param client vim.lsp.Client
local function create_on_list(client)
  ---@param opts vim.lsp.LocationOpts.OnList
  return function(opts)
    -- the `user_data` field contains the original location data from the server.
    lsp.util.show_document(opts.items[1].user_data, client.offset_encoding, {
      focus = true,
      reuse_win = false,
    })
    if vim.tbl_count(opts.items) > 1 then
      ---@diagnostic disable-next-line: param-type-mismatch
      fn.setqflist({}, ' ', opts)
      api.nvim_command('copen | wincmd p')
    end
    eo.center_cursor()
  end
end

-- local original_handler = lsp.handlers[M.textDocument_publishDiagnostics]

lsp.handlers['window/logMessage'] = function(_, content, _)
  if content.type == 3 then
    if content.message:find('pythonPath') then vim.notify(content.message) end
  end
end

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

--[[ from the help docs ]]

---@param diagnostick? vim.Diagnostic
---@param bufnr integer
-- local function on_jump(diagnostick, bufnr)
--   if not diagnostick then return end
--
--   diagnostic.show {
--     diagnostick.namespace,
--     bufnr,
--     { diagnostick },
--     { virtual_lines = { current_line = true }, virtual_text = false },
--   }
-- end

diagnostic.handlers.loclist = {
  show = function(_, _, _, opts)
    opts.loclist.open = opts.loclist.open or false
    local winid = api.nvim_get_current_win()
    diagnostic.setloclist(opts.loclist)
    api.nvim_set_current_win(winid)
  end,
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
  signs = {
    text = {
      [S.WARN] = lsp_icons.warn,
      [S.INFO] = lsp_icons.info,
      [S.HINT] = lsp_icons.hint,
      [S.ERROR] = lsp_icons.error,
    },
  },
  -- loclist = {
  --   open = true,
  --   severity = { min = S.ERROR },
  -- },
  float = {
    -- namespace = ns,
    max_width = max_width,
    max_height = max_height,
    border = eo.ui.current.border,
    title = { { '  ', 'DiagnosticFloatTitleIcon' }, { 'Problems ', 'DiagnosticFloatTitle' } },
    focusable = false, -- no need to enter these windows
    -- header = '',
    scope = 'line', -- to keep inline with diagflow.nvim
    prefix = function(diag)
      local level = S[diag.severity]
      local prefix = fmt('%s ', lsp_icons[level:lower()])
      return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
    end,
    ---[[ www.github.com/willothy/nvim-config/blob/main/lua/configs/lsp/lspconfig.lua ]]
    source = 'if_many', -- true | 'if_many'
    header = setmetatable({}, {
      __index = function(_, k)
        local arr = {
          fmt(
            'Diagnostics: %s %s',
            require('nvim-web-devicons').get_icon_by_filetype(vim.bo.filetype),
            vim.bo.filetype
          ),
          'Title',
        }
        return arr[k]
      end,
    }),
  },
}
