local api = vim.api

local M = {}

local has_ts, ts = pcall(require, 'vim.treesitter')
local make_cond = require('luasnip.extras.conditions').make_condition

--- Get current node under the cursor if treesitter has a parser
M.get_node_at_cursor = function()
  local cursor = api.nvim_win_get_cursor(0)
  local cursor_range = { cursor[1] - 1, cursor[2] }
  local lang = api.nvim_buf_get_option(0, 'ft')
  lang = lang == 'tex' and 'latex' or lang
  local ok, status = pcall(ts.get_parser, 0, lang)
  if not ok or not parser then return end
  local root_tree = parser:parse()[1]
  local root = root_tree and root_tree:root()

  if not root then return end

  return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

-- check if the current cursor position is in a comment
---@return boolean in_comment
M.in_comment = make_cond(function(_, _, _)
  if not has_ts then return false end
  local node = M.get_node_at_cursor()
  while node do
    if node:type() == 'comment' then return true end
    node = node:parent()
  end
  return false
end)

return M
