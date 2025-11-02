if not eo or vim.g.vscode then return end

local api, lsp, fn, fs, fmt = vim.api, vim.lsp, vim.fn, vim.fs, string.format

local diagnostic = vim.diagnostic

local L, M, S = lsp.log_levels, lsp.protocol.Methods, diagnostic.severity

local extensions = require('eo.lsp.extensions')
local border = eo.ui.current.border

lsp.set_log_level(L.WARN)
require('vim.lsp.log').set_format_func(vim.inspect)

vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gra')

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

-- Create a function that will perform the file renaming operation using the given LSP `client`.
-- ---@param client vim.lsp.Client

--[[
-- from dhruvmanila's dotfiles:
-- https://github.com/dhruvmanila/dotfiles/blob/master/config/nvim/plugin/lsp/attach.lua
--]]

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

local lsp_attach_group = api.nvim_create_augroup('eo-lsp-attach', { clear = true })
api.nvim_create_autocmd('LspAttach', {
  -- group = api.nvim_create_augroup('eo-lsp-attach', { clear = true }),
  group = lsp_attach_group,
  desc = 'LSP Actions',
  callback = function(event)
    local buf = event.buf

    --- shortcut function to map kes
    ---@param key string|table
    ---@param desc string
    ---@param func function|string
    ---@param mode? string|table
    ---@return nil
    local _map = function(keys, desc, func, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = buf, desc = 'LSP: ' .. desc })
    end

    -- _map('<leader>dt', 'Toggle diagnostics', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)

    --[[ next to keymaps are reversed where `[d` goes forward, only due to physiology & 
        `[` is easier to press over and over again... yes I have many errors in the code :(
    --]]

    _map('[d', 'Diag: goto prev', function() vim.diagnostic.jump { count = 1 } end)

    _map(']d', 'Diag: goto next', function() vim.diagnostic.jump { count = -1 } end)

    -- _map('gd', 'lsp: [g]oto [d]ef', function() lsp.buf.definition() end)
    _map('gd', '[g]oto [d]ef', function() require('glance').open('definitions') end)
    -- vim.lsp.buf.definition = require('glance').open('definitions')

    -- if client and client_supports_method(client, M.textDocument_definition, event.buf) then
    --   _map('gd', '[g]oto [d]definition', function() lsp.buf.definition { on_list = create_on_list(client) } end)
    -- end

    -- _map('gD', 'lsp: [g]oto type [d]ef', function() lsp.buf.type_definition() end)
    _map('gD', '[g]oto type [d]ef', function() require('glance').open('type_definitions') end)

    -- _map('gi', 'lsp: [g]oto [i]mplementation', function() lsp.buf.implementation() end)
    _map('gi', '[g]oto [i]mplementation', function() require('glance').open('implementations') end)

    -- _map('gr', '[g]oto [r]references', function() lsp.buf.references { includeDeclaration = false } end)
    _map('gr', '[g]oto [r]references', function() require('glance').open('references') end)

    _map('<leader>rn', '[r]e[n]ame all symbol references', function() lsp.buf.rename() end)

    -- _map('x', '<leader>ca', 'lsp: select [c]ode [a]ction', function() lsp.buf.code_action() end)
    _map('<leader>ca', 'select [c]ode [a]ction', function() lsp.buf.code_action() end, { 'n', 'x' })

    _map('<leader>cl', 'run [c]ode [l]ens', function() lsp.codelens.run() end)

    _map('<leader>chb', '[c]hange inlay [h]int (for [b]buffer)', function()
      local is_enabled = lsp.inlay_hint.is_enabled { bufnr = event.buf }
      lsp.inlay_hint.enable(not is_enabled, { bufnr = event.buf })
    end)

    _map('<leader>chg', '[c]hange inlay [h]int [g]lobally', function()
      local is_enabled = lsp.inlay_hint.is_enabled()
      lsp.inlay_hint.enable(not is_enabled)
    end)

    -- local function rename_file(client)
    --   local old_fname = api.nvim_buf_get_name(0)
    --   vim.ui.input({ prompt = 'New file name:' }, function(name)
    --     if name == nil then return end
    --     local new_fname = ('%s/%s'):format(vim.fs.dirname(old_fname), name)
    --     local params = {
    --       files = {
    --         { oldUri = 'file://' .. old_fname, newUri = 'file://' .. new_fname },
    --       },
    --     }
    --     ---@diagnostic disable-next-line: missing-parameter `bufnr` is optional
    --     local response = client:request_sync(M.workspace_willRenameFiles, params, 1000)
    --     if not response then
    --       vim.notify(fmt('No response from %s client for %s', client.name), 'info', { title = 'LSP' })
    --       return
    --     end
    --     if response.err then
    --       vim.notify(
    --         fmt('Failed to rename %s to %s: %s', old_fname, new_fname, response.err),
    --         'error',
    --         { title = 'LSP' }
    --       )
    --     else
    --       lsp.util.apply_workspace_edit(response.result, client.offset_encoding)
    --       lsp.util.rename(old_fname, new_fname)
    --     end
    --   end)
    -- end

    -- _map('<leader>cfN', 'lsp: [c]hange [f]ile[n]ame', function() rename_file(client) end)

    -- This function resolves a difference between nvim nightly (>=0.11) and stable (0.10)
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr) return client:supports_method(method, bufnr) end

    -- local client = assert(lsp.get_client_by_id(event.data.client_id))
    local client = lsp.get_client_by_id(event.data.client_id)

    local client_extension = extensions[client.name]
    if client_extension ~= nil then client_extension.on_attach { client, bufnr = event.buf } end
    -- if client_extension ~= nil then client_extension.on_attach { client, bufnr = buf } end

    -- if client and client_supports_method(client, M.textDocument_completion) then
    --   lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    -- end

    if client and client_supports_method(client, M.textDocument_documentSymbol, event.buf) then
      require('nvim-navic').attach(client, event.buf)
    end

    if client and client_supports_method(client, M.textDocument_documentHighlight, event.buf) then
      -- if client and client_supports_method(client, M.textDocument_documentHighlight, buf) then
      local highlight_augroup = api.nvim_create_augroup('eo-lsp-highlight', { clear = false })

      api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        -- buffer = buf,
        callback = lsp.buf.document_highlight,
        group = highlight_augroup,
      })

      api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        -- buffer = buf,
        callback = lsp.buf.clear_references,
        group = highlight_augroup,
      })

      api.nvim_create_autocmd('LspDetach', {
        group = api.nvim_create_augroup('eo-lsp-detach', { clear = true }),
        callback = function(event2)
          lsp.buf.clear_references()
          api.nvim_clear_autocmds { group = 'eo-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- if client and client_supports_method(client, M.textDocument_documentSymbol, buf) then
    --   require('nvim-navic').attach(client, buf)
    -- end

    if client and client_supports_method(client, M.textDocument_codeLens, event.buf) then
      -- if client and client_supports_method(client, M.textDocument_codeLens, buf) then
      local codeLens_augroup = api.nvim_create_augroup('eo-lsp-codeaction', { clear = false })
      api.nvim_clear_autocmds { buffer = buf, group = codeLens_augroup }
      api.nvim_create_autocmd({ 'CursorHold', 'TextChanged', 'InsertLeave', 'LspAttach', 'BufEnter' }, {
        group = codeLens_augroup,
        buffer = event.buf,
        callback = function() lsp.codelens.refresh { bufnr = event.buf } end,
        -- buffer = buf,
        -- callback = function() lsp.codelens.refresh { bufnr = buf } end,
        desc = 'lsp: refresh codelens',
      })
    end

    if
      vim.lsp['inlay_hint'] ~= nil
      and client
      and client_supports_method(client, M.textDocument_inlayHint, event.buf)
      -- and client_supports_method(client, M.textDocument_inlayHint, buf)
    then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      -- vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end

    if
      client
      and diagnostic.is_enabled ~= nil
      and client_supports_method(client, M.textdocument_diagnostic, event.buf)
      -- and client_supports_method(client, M.textdocument_diagnostic, buf)
    then
      local lspformat_augroup = api.nvim_create_augroup('eo-lsp-format', { clear = false })
      api.nvim_create_autocmd('CursorHold', {
        buffer = event.buf,
        -- buffer = buf,
        callback = function()
          diagnostic.open_float(nil, {
            focusable = false,
            close_events = {
              'BufLeave',
              'CursorMoved',
              'InsertEnter',
              'FocusLost',
            },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
            scope = 'cursor',
          })
        end,
        group = lspformat_augroup,
      })
    end
  end,
})

-- if client:supports_method(M.textDocument_declaration) then
--   map('n', 'gD', function() lsp.buf.declaration { on_list = create_on_list(client) } end, {
--     buffer = bufnr,
--     desc = 'lsp: [g]oto [D]eclaration',
--   })
-- end

-- if client and client_supports_method(client, M.textDocument_typeDefinition, event.buf) then
--   map('n', 'gD', lsp.buf.type_definition(), { buffer = bufnr, desc = 'lsp: [g]oto [d]ef' })
--
--   --   map('n', 'gD', function() lsp.buf.type_definition { on_list = create_on_list(client) } end, {
--   --     buffer = bufnr,
--   --     desc = 'lsp: [g]oto t[y]pe definition',
--   --   })
-- end

-- if client and client_supports_method(client, M.textDocument_implementation, event.buf) then
--   map('n', 'gi', lsp.buf.implementation(), {
--     buffer = bufnr,
--     desc = 'lsp: [g]oto [i]mplementation',
--   })
-- end

-- if client and client_supports_method(client, M.textDocument_references, event.buf) then
--   map('n', 'gr', function() lsp.buf.references { includeDeclaration = false } end, {
--     buffer = bufnr,
--     desc = 'lsp: [g]oto [r]references',
--   })
-- end

-- if client and client_supports_method(client, M.textDocument_rename, event.buf) then
--   map('n', '<leader>rn', lsp.buf.rename, {
--     buffer = bufnr,
--     desc = 'lsp: [r]e[n]ame all symbol references',
--   })
-- end

-- if client and client_supports_method(client, M.textDocument_codeAction, event.buf) then
--   map({ 'n', 'x' }, '<leader>ca', lsp.buf.code_action, {
--     buffer = bufnr,
--     desc = 'lsp: select [c]ode [a]ction',
--   })
-- end

-- if client and client_supports_method(client, M.textDocument_codeLens, event.buf) then
--   map('n', '<leader>cl', lsp.codelens.run, {
--     buffer = bufnr,
--     desc = 'lsp: run [c]ode [l]ens',
--   })
-- end

-- if vim.lsp['inlay_hint'] ~= nil and client and client_supports_method(client, M.textDocument_inlayHint, event.buf) then
--   map('n', '<leader>ci', function()
--     local is_enabled = lsp.inlay_hint.is_enabled { bufnr = bufnr }
--     lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
--   end, { desc = 'lsp: toggle [i]nlay [h]int for buffer' })
--
--   map('n', '<leader>iH', function()
--     local is_enabled = lsp.inlay_hint.is_enabled()
--     lsp.inlay_hint.enable(not is_enabled)
--   end, { desc = 'lsp: toggle [i]nlay [H]int globally' })
-- end

-- if client and client_supports_method(client, M.workspace_willRenameFiles, event.buf) then
--   map('n', '<leader>rN', function() rename_file(client) end, {
--     buffer = bufnr,
--     desc = 'lsp: [r]ename [f]ile',
--   })
-- end

-----------------------------------------------------------------------------//
-- Autocommands
-----------------------------------------------------------------------------//

-- ---@param client lsp.Client
-- ---@param buf integer

-- local function setup_autocmds(client, bufnr)
--   -- if client:supports_method(M.textDocument_documentHighlight) then
--   --   -- augroup(('LspReferences%d'):format(buf), {
--   --   --   event = { 'CursorHold', 'CursorHoldI' },
--   --   --   buffer = buf,
--   --   --   desc = 'LSP: References',
--   --   --   command = function() lsp.buf.document_highlight() end,
--   --   -- }, {
--   --   --   event = 'CursorMoved',
--   --   --   desc = 'LSP: References Clear',
--   --   --   buffer = buf,
--   --   --   command = function() lsp.buf.clear_references() end,
--   --   -- })
--   --   local group = api.nvim_create_augroup('eo__lsp_', { clear = false })
--   --   api.nvim_clear_autocmds { buffer = bufnr, group = group }
--   --   api.nvim_create_autocmd('CursorHold', {
--   --     group = group,
--   --     buffer = bufnr,
--   --     callback = lsp.buf.document_highlight,
--   --     desc = 'lsp: document highlight',
--   --   })
--   --   api.nvim_create_autocmd('CursorMoved', {
--   --     group = group,
--   --     buffer = bufnr,
--   --     callback = lsp.buf.clear_references,
--   --     desc = 'lsp: clear references',
--   --   })
--   -- end
--
--   -- if client:supports_method(M.textDocument_codeLens) then
--   --   -- augroup(('LspCodeLens%d'):format(buf), {
--   --   --   event = { 'BufEnter', 'InsertLeave', 'BufWritePost' },
--   --   --   desc = 'LSP: Code Lens',
--   --   --   buffer = buf,
--   --   --   -- call via vimscript so that errors are silenced
--   --   --   command = 'silent! lua vim.lsp.codelens.refresh()',
--   --   -- })
--   --   local group = api.nvim_create_augroup('eo__lsp_', { clear = false })
--   --   api.nvim_clear_autocmds { buffer = bufnr, group = group }
--   --   api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
--   --     group = group,
--   --     buffer = bufnr,
--   --     callback = function() lsp.codelens.refresh { bufnr = bufnr } end,
--   --     desc = 'lsp: refresh codelens',
--   --   })
--   -- end
-- end

---@param client vim.lsp.Client
---@param bufnr number
-- local function on_attach(client, bufnr)
--   -- setup_mappings(client, bufnr)
--   -- setup_autocmds(client, bufnr)
--
--   local client_extension = extensions[client.name]
--   if client_extension then client_extension.on_attach(client, bufnr) end
-- end

-- local group = api.nvim_create_augroup('eo__lsp_', { clear = true })
-- api.nvim_create_autocmd('LspAttach', {
--   group = api.nvim_create_augroup('eo__lsp_', { clear = true }),
--   callback = function(event)
--     local client = lsp.get_client_by_id(event.data.client_id)
--     if client == nil then return end
--     on_attach(client, event.buf)
--   end,
--   desc = 'lsp: setup language servers',
-- })

-- api.nvim_create_autocmd('LspDetach', {
--   group = api.nvim_create_augroup('eo__lsp_detach', { clear = true }),
--   callback = function(event2)
--     vim.lsp.buf.clear_references()
--     vim.lsp.nvim_clear_autocmds {
--       group = 'eo__lsp_',
--     }
--   end,
-- })
