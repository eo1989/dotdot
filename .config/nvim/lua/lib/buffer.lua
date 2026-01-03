local M = {}

local api, cmd = vim.api, vim.cmd

---@param bufnr integer?
---@return string[] Selected text as a string, or nil if not in visual mode or selection is empty.
M.visual_selection = function(bufnr)
  cmd.normal { 'v', bang = true }

  bufnr = bufnr or 0

  local start = api.nvim_buf_get_mark(bufnr, '<')
  local finish = api.nvim_buf_get_mark(bufnr, '>')

  if start[1] == 0 or finish[1] == 0 then return {} end

  return api.nvim_buf_get_text(bufnr, start[1] - 1, start[2], finish[1] - 1, finish[2] + 1, {})
end

---@param bufnr integer?
M.code_block = function(bufnr)
  local lines = M.visual_selection(bufnr)

  -- find minimum indent
  local min_indent = math.huge

  for _, line in ipairs(lines) do
    if line:match('%S') then -- skip empty lines
      local ws = line:match('^%s*')

      if ws then min_indent = math.min(min_indent, ws:len()) end
    end
  end

  -- dedent lines
  for i, line in ipairs(lines) do
    if line:match('%S') then lines[i] = line:sub(math.floor(min_indent) + 1) end
  end

  return table.concat(lines, '\n')
end

return M
