local api, ts = vim.api, vim.treesitter
local b, wo = vim.b, vim.wo

b.slime_cell_delimiter = '```'
b['quarto_is_r_mode'] = nil
b['reticulate_running'] = false

wo.wrap = true
wo.linebreak = true
wo.breakindent = true
wo.showbreak = '|'

api.nvim_buf_set_var(0, 'did_ftplugin', true)

-- md vs qmd hacks
local ns = api.nvim_create_namespace('QuartoHighlight')
api.nvim_set_hl(ns, '@markup.strikethrough', { strikethrough = false })
api.nvim_set_hl(ns, '@markup.doublestrikethrough', { strikethrough = true })
api.nvim_win_set_hl_ns(0, ns)

-- ts based code chun highlighting uses a change
-- only available in nvim >= 0.10

if vim.fn.has('nvim-0.10.0') == 0 then return end

-- hl code cells similar to `lukas-reineke/headlines.nvim`
local buf = api.nvim_get_current_buf()

local parsername = 'markdown'
local parser = ts.get_parser(buf, parsername)
local tsquery = '(fenced_code_block)@codecell'

api.nvim_set_hl(0, '@markup.codecell', { link = 'CursorLine' })

local function clear_all()
  local all = api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
  for _, mark in ipairs(all) do
    api.nvim_buf_del_extmark(buf, ns, mark[1])
  end
end

local function highlight_range(from, to)
  for i = from, to do
    api.nvim_buf_add_extmark(buf, ns, i, 0, { hl_eol = true, line_hl_group = '@markup.codecell' })
  end
end

local function highlight_cells()
  clear_all()

  local query = ts.query.parse(parsername, tsquery)
  local tree = parser:parse()
  local root = tree[1]:root()
  for _, match, _ in query:iter_matches(root, buf, 0, -1, { all = true }) do
    for _, nodes in pairs(match) do
      for _, node in ipairs(nodes) do
        local start_line, _, end_line, _ = node:range()
        pcall(highlight_range, start_line, end_line - 1)
      end
    end
  end
end

higlight_cells()

api.nvim_create_autocmd({ 'ModeChanged', 'BufWrite' }, {
  group = api.nvim_create_augroup('QuartoCellHighlight', { clear = true }),
  buffer = buf,
  callback = highlight_cells,
})
