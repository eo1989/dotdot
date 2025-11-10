-- local M = {}
--- VSCode-like lightbulb.
--- Implementation inspired from https://github.com/nvimdev/lspsaga.nvim/blob/a751b92b5d765a99fe3a42b9e51c046f81385e15/lua/lspsaga/codeaction/lightbulb.lua

local api, lsp, uv = vim.api, vim.lsp, vim.uv
local lb_name = 'nvim/lighbulb'
local lb_namespace = api.nvim_create_namespace(lb_name)
local lb_icon = require('defaults').icons.diagnostics.hint
local lb_group = api.nvim_create_augroup(lb_name, {})
local code_action_method = lsp.protocol.Methods.textDocument_codeAction

local timer = uv.new_timer()
assert(timer, 'Timer wasnt initiated')

local updated_bufnr = nil

--- updates the current bulb
---@param bufnr number?
---@param line number?
local function update_extmark(bufnr, line)
  if not bufnr or not api.nvim_buf_is_valid(bufnr) then return end

  api.nvim_buf_clear_namespace(bufnr, lb_namespace, 0, -1)

  -- extra check for not being in insert mode here bc sometimes the autocmd fails
  if not line or vim.startswith(api.nvim_get_mode().mode, 'i') then return end

  pcall(api.nvim_buf_set_extmark, bufnr, lb_namespace, line, -1, {
    virt_text = { { ' ' .. lb_icon, 'DiagnosticSignHint' } },
    hl_mode = 'combine',
  })

  updated_bufnr = bufnr
end

--- Queries the lsp server for code actions and updates the lightbulb
---@param bufnr number
---@param client vim.lsp.Client
local function render(bufnr, client)
  local winnr = api.nvim_get_current_win()
  if api.nvim_win_get_buf(winnr) ~= bufnr then return end

  local line = api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = lsp.diagnostic.from(lsp.diagnostic.get_line_diagnostics(bufnr, { lnum = line }))

  ---@type lsp.CodeActionOptions
  local params = lsp.util.make_range_params(winnr, client.offset_encoding)
  params.context = {
    diagnostics = diagnostics,
    triggerKind = lsp.protocol.CodeActionTriggerKind.Automatic,
  }

  lsp.buf_request(bufnr, code_action_method, params, function(_, res, _)
    if api.nvim_get_current_buf() ~= bufnr then return end

    updated_extmark(bufnr, (res and #res > 0 and line) or nil)
  end)
end

-- from lspsaga
---@param bufnr number
---@param client vim.lsp.Client
local function update(bufnr, client)
  timer:stop()
  update_extmark(updated_bufnr)
  timer:start(100, 0, function()
    timer:stop()
    vim.schedule(function()
      if api.nvim_buf_is_valid(bufnr) and api.nvim_get_current_buf() ~= bufnr then render(bufnr, client) end
    end)
  end)
end

---@param bufnr integer
---@param client_id integer
M.attach_lightbulb = function(bufnr, client_id)
  local client = lsp.get_client_by_id(client_id)

  if not client or not client:supports_method(code_action_method) then return end

  local buf_group_name = lb_name .. tostring(bufnr)
  if pcall(api.nvim_get_autocmds, { group = buf_group_name, buffer = bufnr }) then return end

  local lb_buf_group = api.nvim_create_augroup(buf_group_name, { clear = true })
  api.nvim_create_autocmd('CursorMoved', {
    group = lb_buf_group,
    desc = 'Update lightbulb when moving the cursor in normal/visual mode',
    buffer = bufnr,
    callback = function() update(bufnr, client) end,
  })

  api.nvim_create_autocmd({ 'InsertEnter', 'BufLeave' }, {
    group = lb_buf_group,
    desc = 'Update lightbulb when entering insert mode or leaving the buffer',
    buffer = bufnr,
    callback = function() update_extmark(bufnr, nil) end,
  })

  api.nvim_create_autocmd('LspDetach', {
    group = lb_group,
    desc = 'Detach code action lightbulb',
    buffer = bufnr,
    callback = function() pcall(api.nvim_del_augroup_by_name, lb_name .. tostring(bufnr)) end,
  })
end

return M
