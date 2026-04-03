local api = vim.api

---@return TSNode|nil
local function current_node()
  local bufnr = api.nvim_get_current_buf()
  local parser = vim.treesitter.get_parser(bufnr, 'org')
  local root = parser:parse()[1]:root()
  local cursor_pos = api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1] - 1, cursor_pos[2] - 1
  local node = root:named_descendent_for_range(row, col, row, col)
  return node
end

---@param node TSNode | nil
---@return TSNode | nil
local function get_parent_block(node)
  if not node then return nil end
  if node:type() == 'block' then return node end
  local parent = node:parent()
  while parent do
    if parent:type() == 'block' then return parent end
    parent = parent:parent()
  end
  return nil
end

---@param bufnr integer
---@param node TSNode
---@return integer|nil
local function get_next_node_result_end_row(bufnr, node)
  local next_sibling = node:next_named_sibling()
  if not next_sibling then return nil end
  if next_sibling and next_sibling:type() == 'paragraph' then
    if next_sibling:child(0) == nil then return nil end

    local field_name = next_sibling:child(0):field('name')[1]
    if not field_name then return nil end
    local field_name_text = vim.treesitter.get_node_text(field_name, bufnr)

    if field_name_text == 'results' then
      local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(next_sibling)
      return end_row + 1
    end
  end
  return nil
end

---@param row integer
---@param output string[]
local function insert_after_lines(row, output)
  local bufnr = api.nvim_get_current_buf()
  api.nvim_buf_set_lines(bufnr, row + 1, row + 1, false, output)
end

---@param d {status: string, message: string}
local api_listener = function(d)
  -- check if current file is an org file
  local bufnr = api.nvim_get_current_buf()
  local filetype = api.nvim_get_option_value('filetype', { buf = bufnr })
  if filetype ~= 'org' then
    print(d.message)
    return
  end

  if d.message == '' then
    print('No output from SnipRun')
    return
  end

  local node = current_node()
  if not node then return end

  local block_node = get_parent_block(node)
  if not block_node then
    -- print("No parent block found")
    return
  end

  local bufnr = api.nvim_get_current_buf()

  -- Check if immediate next sibling contains a results block
  local results_end_row = get_next_node_result_end_row(bufnr, block_node)
  local output = vim.split(d.message, '\n', { plain = true })
  -- Add empty line after output
  table.insert(output, '')

  if results_end_row then
    -- Results block exists, replace the entire paragraph containing it
    local new_results = { '#+results:' }
    for _, line in ipairs(output) do
      table.insert(new_results, line)
    end
    -- Find the start of the results block by going back from the end
    local next_sibling = block_node:next_sibling()
    if next_sibling then
      local results_start_row = next_sibling:start() + 1
      vim.api.nvim_buf_set_lines(bufnr, results_start_row, results_end_row, false, new_results)
    end
  else
    -- No results block, create new one
    local block_end_row = block_node:end_()
    local results_output = { '#+results:' }
    for _, line in ipairs(output) do
      table.insert(results_output, line)
    end
    insert_after_lines(block_end_row, results_output)
  end
end

require('sniprun').register_listener(api_listener)
