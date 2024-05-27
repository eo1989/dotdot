if not eo then return end
local api, map = vim.api, vim.keymap.set

-- for _, mode in ipairs { 'n', 'v' } do
--   map(mode, 'H', '^', { noremap = true })
--   map(mode, 'L', 'g_', { noremap = true })
-- end

-- Remap for dealing with word wrap
-- map('n', 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
map('n', 'k', [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })
-- map('n', 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map('n', 'j', [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })

-- Better viewing
map('n', 'g,', 'g,zvzz')
map('n', 'g;', 'g;zvzz')

map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Scrolling
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Zero should go to the first non-blank character not to the first column (which could be blank)
-- but if already at the first character then jump to the beginning
--@see: https://github.com/yuki-yano/zero.nvim/blob/main/lua/zero.lua
map('n', '0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true, noremap = true })

-- when going to the end of the line in visual mode ignore whitespace characters
map('v', '$', 'g_', { noremap = true })

-- stylua: ignore start
map('n', [[<leader>"]], [[ciw"<c-r>""<esc>]], { desc = 'surround with double quotes', noremap = true })
map('n', '<leader>`',   [[ciw`<c-r>"`<esc>]], { desc = 'surround with backticks',     noremap = true })
map('n', "<leader>'",   [[ciw'<c-r>"'<esc>]], { desc = 'surround with single quotes', noremap = true })
map('n', '<leader>)',   [[ciw(<c-r>")<esc>]], { desc = 'surround with parens',        noremap = true })
map('n', '<leader>}',   [[ciw{<c-r>"}<esc>]], { desc = 'surround with curly braces',  noremap = true })
-- stylua: ignore end

map('n', 'gf', '<cmd>e <cfile><CR>', { noremap = true })

-- Better escape using jk in insert and terminal mode
map('i', 'kj', [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true, nowait = true })

map('t', 'kj', '<C-\\><C-n>', { nowait = true })
map('t', '<C-h>', '<C-\\><C-n><C-w>h')
map('t', '<C-j>', '<C-\\><C-n><C-w>j')
map('t', '<C-k>', '<C-\\><C-n><C-w>k')
map('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- Better indent
-- map('v', '<', '<gv')
-- map('v', '>', '>gv')

-- even better indent (wont kick you out of visual mode this time) ty famiu/dot-nvim/blob/master/lua/keybinds.lua
map('v', '<', '<gv^')
map('v', '>', '>gv^')
-- apply the . cmd to all selected lines in visual mode; again, ty famiu
map('v', '.', ':normal .<CR>', { silent = true })

-- in case bufferline isnt setup or for whatever 4932849023840x10^3982498 reasons my config decides to fubar my day...
map('n', '<leader><Tab>', ':bn<CR>', { silent = true }) -- (or :bn<cr>)
map('n', '<leader><S-Tab>', ':bp<CR>', { silent = true }) -- (or :bp<cr>)

-- Paste over currently selected text without yanking it
map('v', 'p', '"_dp')

-- select pasted text, famiuuuuu
-- map('n', '<leader>pv', "'[v']")

-- Insert blank line
-- map('n', ']<Space>', 'o<Esc>')
map('n', ']<Space>', [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]], { desc = 'add space below' })
-- map('n', '[<Space>', 'O<Esc>')
map('n', '[<Space>', [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]], { desc = 'add space below' })

-- Auto indent
map('n', 'i', function()
  if #vim.fn.getline('.') == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true })

---@akinshooooooooooo (nightly nvim dotfiles)
map('n', 'g>', [[<cmd>set nomore<bar>40messages<bar>set more<CR>]], { desc = 'show message history', noremap = true })

map('n', 'zO', [[zCzO]], { noremap = true })

-- TLDR: Conditionally modify character at end of line
-- Description:
-- This function takes a delimiter character and:
--   * removes that character from the end of the line if the character at the end
--     of the line is that character
--   * removes the character at the end of the line if that character is a
--     delimiter that is not the input character and appends that character to
--     the end of the line
--   * adds that character to the end of the line if the line does not end with
--     a delimiter
-- Delimiters:
-- - ","
-- - ";"
--@param chars string
--@return function
local function modify_line_end_delimiter(chars)
  local delims = { ',', ';' }
  return function()
    local line = api.nvim_get_current_line()
    local last_char = line:sub(-1)
    if last_char == chars then
      api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(delims, last_char) then
      api.nvim_set_current_line(line:sub(1, #line - 1) .. chars)
    else
      api.nvim_set_current_line(line .. chars)
    end
  end
end

map('n', '<localleader>,', modify_line_end_delimiter(','), { desc = "add ',' to the end of line", noremap = true })

map('n', '<localleader>;', modify_line_end_delimiter(';'), { desc = "add ';' to the end of line", noremap = true })

map('n', '<leader>E', '<Cmd>Inspect<CR>', { desc = 'Inspect the cursor position', noremap = true })

map('n', '<A-k>', '<Cmd>move-2<CR>==', { noremap = true, silent = true })
map('n', '<A-j>', '<Cmd>move+<CR>==', { noremap = true, silent = true })
map('x', '<A-k>', ":move-2<CR>='[gv", { noremap = true, silent = true })
map('x', '<A-j>', ":move'>+<CR>='[gv", { noremap = true, silent = true })

map('v', 'J', [[:move '>+1<CR>gv=gv]], { silent = true })
map('v', 'K', [[:move '<-2<CR>gv=gv]], { silent = true })

-- windows
map(
  'n',
  '<localleader>wh',
  '<C-W>t <C-W>K',
  { desc = 'change two horizontally split windows to vertical splits', noremap = true }
)

map(
  'n',
  '<localleader>wv',
  '<C-W>t <C-W>H',
  { desc = 'change two vertically split windows to horizontal splits', noremap = true }
)

map(
  'n',
  '<leader>[',
  [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]],
  { silent = false, desc = 'replace word under the cursor(file)' }
)

map(
  'n',
  '<leader>]',
  [[:s/\<<C-r>=expand("<cword>")<CR>\>/]],
  { silent = false, desc = 'replace word under the cursor (line)' }
)

map('v', '<leader>[', [["zy:%s/<C-r><C-o>"/]], { silent = false, desc = 'replace word under the cursor (visual)' })

if vim.fn.bufwinnr(1) then
  map('n', '<A-h>', '<C-W><')
  map('n', '<A-l>', '<C-W>>')
end
-- Default maps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
