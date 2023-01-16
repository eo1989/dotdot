---@diagnostic disable: redundant-parameter
if not as then return end --@diagnostic disable:

local fn, api = vim.fn, vim.api
local command = as.command
local fmt = string.format

-- local map = vim.keymap.set

local nmap = as.nmap
local vmap = as.vmap
local imap = as.imap
local nnoremap = as.nnoremap
local xnoremap = as.xnoremap
local vnoremap = as.vnoremap
local inoremap = as.inoremap
local onoremap = as.onoremap
local cnoremap = as.cnoremap
local tnoremap = as.tnoremap

vim.cmd([[map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>]])

-----------------------------------------------------------------------------//
-- Terminal {{{
------------------------------------------------------------------------------//
as.augroup('AddTerminalMappings', {
  {
    event = { 'TermOpen' },
    pattern = { 'term://*' },
    command = function()
      if vim.bo.filetype == '' or vim.bo.filetype == 'toggleterm' then
        local opts = { silent = false, buffer = 0 }
        tnoremap('<esc>', [[<C-\><C-n>]], opts)
        tnoremap('kj', [[<C-\><C-n>]], opts)
        tnoremap('<C-h>', '<Cmd>wincmd h<CR>', opts)
        tnoremap('<C-j>', '<Cmd>wincmd j<CR>', opts)
        tnoremap('<C-k>', '<Cmd>wincmd k<CR>', opts)
        tnoremap('<C-l>', '<Cmd>wincmd l<CR>', opts)
        tnoremap(']t', '<Cmd>tablast<CR>')
        tnoremap('[t', '<Cmd>tabnext<CR>')
        tnoremap('<[b>', '<Cmd>bprev<CR>')
        tnoremap('<leader><Tab>', '<Cmd>close \\| :bnext<cr>')
      end
    end,
  },
})
--}}}

-----------------------------------------------------------------------------//
-- MACROS {{{
-----------------------------------------------------------------------------//
-- Absolutely fantastic function from stoeffel/.dotfiles which allows you to
-- repeat macros across a visual range
------------------------------------------------------------------------------
-- TODO: converting this to lua does not work for some obscure reason.
vim.cmd([[
  function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
  endfunction
]])

xnoremap('@', ':<C-u>call ExecuteMacroOverVisualRange()<CR>', { silent = false })
--}}}

-- importantest remap ever!
-- nnoremap(';', ':', { silent = false })

-- launch current buffer in a new kitty tab!
-- (requires the current term instance to be started with kitty -o allow_remote_control=yes
-- --listen-on unix:/tmp/mykitty )
-- nnoremap('<F10>', '<Cmd>!kitty @ launch --type=tab --cwd=current --location=neighbor nvim %<CR>')

---@eo {{{run shit and comment shit out! check out sniprun, jukit, magma, coderunner, termexec, etc etc
-- local toggle_sniprun = function()
--   local snip_funcs = require('as.snip_funcs') --.toggle_sniprun
--   if vim.bo['filetye']('python') == 1 then
--     snip_funcs['toggle_sniprun'] 
--   end
-- end
-- nnoremap('<localleader>r', "<Plug>SnipRun")
-- map({ 'n', 'v' }, '<localleader>r', '<Plug>SnipRun', { buffer = true })
-- map(
--   { 'n', 'v', 'x' },
--   '<M-r>',
--   '<cmd>let b:caret = winsaveview()<CR><bar><Cmd><Plug>SnipRun<CR><bar><CMD>call winrestview(b:caret)<CR>',
--   { buffer = true }
-- )

vmap('<localleader>rs', "<cmd>lua require('sniprun').run('v')<CR>", { silent = false } )
-- vmap('<localleader>rs',  function () require('sniprun').run('v') end, { silent = false } )
-- nmap('<localleader>rf', function() vim.cmd[[%:SnipRun<cr>]] end)
-- nmap('<localleader>rf', function()  end)
-- nnoremap('<localleader>rf', function() require('sniprun').run('n') end, {})
-- vnoremap('<localleader>rf', function() require('sniprun').run('v') end, {})
-- vnoremap('<localleader>rf', [[:'<,'>%SnipRun<CR>]], {silent = false})
-- nmap('<localleader>rf', function() require('sniprun').run('n') end, {silent = false})

-- local show_docs = function()
--   local ft = vim.bo['filetype']
--   if vim.tbl_contains({"vim", "help" }, ft) then
--     vim.cmd("h " .. vim.fn.expand "<cword>")
--   elseif vim.tbl_contains({"man"}, ft) then
--     vim.cmd("Man " .. vim.fn.expand "<cword>")
--   elseif vim.tbl_contains({"python"}, ft) then
--     vim.cmd("Man " .. vim.fn.expand "<cword>")
--   elseif vim.fn.expand "%:t" == 'cargo.toml' then
--     require("crates").show_popup()
--   elseif vim.fn.expand "%:t" == 'cargo.toml' then
--     require("crates").show_popup()
--   else
--     vim.lsp.buf.hover()
--   end
--   nnoremap("K", ":lua require('mappings').show_docs()<CR>", {})
-- end


-- map({ 'x', 'v' }, '<A-/>', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')
-- nmap('<A-/>', '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')
-- map('n', '<A-/>', '<CMD>lua require("Comment.api").call("toggle.linewise.current")<CR>g@$')
-- nmap('<A-/>', '<CMD>lua require("Comment.api").call("toggle.linewise.current")<CR>g@$')

--}}}
------------------------------------------------------------------------------
-- Credit: JGunn Choi ?il | inner line
------------------------------------------------------------------------------

-- includes newline
-- xnoremap('al', '$o0')
-- onoremap('al', '<cmd>normal val<CR>')

--No Spaces or CR
-- xnoremap('il', [[<Esc>^vg_]])
-- onoremap('il', [[<cmd>normal! ^vg_<CR>]])
-----------------------------------------------------------------------------//
-- Add Empty space above and below
-----------------------------------------------------------------------------//
nnoremap('[<space>', [[<cmd>put! =repeat(nr2char(10), v:count1)<cr>'[]])
nnoremap(']<space>', [[<cmd>put =repeat(nr2char(10), v:count1)<cr>]])
-----------------------------------------------------------------------------//
-- Paste in visual mode multiple times
xnoremap('p', 'pgvy')
-- search visual selection
vnoremap('//', [[y/<C-R>"<CR>]])

-- Credit: Justinmk
nnoremap('g>', [[<cmd>set nomore<bar>40messages<bar>set more<CR>]])

-- Enter key should repeat the last macro recorded or just act as enter
nnoremap('<leader><CR>', [[empty(&buftype) ? '@@' : '<CR>']], { expr = true })

-- Evaluates whether there is a fold on the current line if so unfold it else return a normal space
nnoremap('<space><space>', [[@=(foldlevel('.')?'za':"\<Space>")<CR>]])
-- Refocus folds
nnoremap('<localleader>z', [[zMzvzz]])
-- Make zO recursively open whatever top level fold we're in, no matter where the
-- cursor happens to be.
nnoremap('zO', [[zCzO]])

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
---@param character string
---@return function
local function modify_line_end_delimiter(character)
  local delimiters = { ',', ';' }
  return function()
    local line = api.nvim_get_current_line()
    local last_char = line:sub(-1)
    if last_char == character then
      api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(delimiters, last_char) then
      api.nvim_set_current_line(line:sub(1, #line - 1) .. character)
    else
      api.nvim_set_current_line(line .. character)
    end
  end
end

nnoremap('<localleader>,', modify_line_end_delimiter(','))
nnoremap('<localleader>;', modify_line_end_delimiter(';'))
-----------------------------------------------------------------------------//

------------------------------------------------------------------------------
-- Buffers
------------------------------------------------------------------------------
nnoremap('<leader>on', [[<cmd>w <bar> %bd <bar> e#<CR>]])
-- Use wildmenu to cycle tabs
nnoremap('<localleader><tab>', [[:b <Tab>]], { silent = false })
-- Switch between the last two files
nnoremap('<S-TAB><S-TAB>', [[<c-^>]])
-----------------------------------------------------------------------------//
-- Capitalize
-----------------------------------------------------------------------------//
nnoremap('<leader>U', 'gUiw`]') -- <leader>u triggers undo plugin!
-- inoremap('<C-u>', '<cmd>norm!gUiw`]a<CR>')
------------------------------------------------------------------------------
-- Moving lines/visual block
------------------------------------------------------------------------------
-- source: https://www.reddit.com/r/vim/comments/i8b5z1/is_there_a_more_elegant_way_to_move_lines_than_eg/
-- Alternatively to allow using alt in macOS without enabling “Use Option as Meta key”

-- nmap('∆', '<a-j>')
-- nmap('˚', '<a-k>')
-- nnoremap('<a-k>', '<cmd>move-2<CR>==')
-- nnoremap('<a-j>', '<cmd>move+<CR>==')
-- xnoremap('<a-k>', ":move-2<CR>='[gv")
-- xnoremap('<a-j>', ":move'>+<CR>='[gv")
----------------------------------------------------------------------------------
-- Windows
----------------------------------------------------------------------------------
-- Change two horizontally split windows to vertical splits
nnoremap('<localleader>wh', '<C-W>t <C-W>K')
-- Change two vertically split windows to horizontal splits
nnoremap('<localleader>wv', '<C-W>t <C-W>H')
-- equivalent to gf but opens the window in a vertical split
-- vim doesn't have a native mapping for this as <C-w>f normally
-- opens a horizontal split
nnoremap('<C-w>f', '<C-w>vgf')
-- find visually selected text
vnoremap('*', [[y/<C-R>"<CR>]])
-- make . work with visually selected lines
vnoremap('.', ':norm.<CR>')
nnoremap('<leader>qw', '<cmd>bd!<CR>')
----------------------------------------------------------------------------------
-- Operators
----------------------------------------------------------------------------------
-- Yank from the cursor to the end of the line, to be consistent with C and D.
-- nnoremap('Y', 'y$')
-----------------------------------------------------------------------------//
-- Quick find/replace
-----------------------------------------------------------------------------//
local noisy = { silent = false }
nnoremap('<leader>[', [[:%s/\<<C-r>=expand("<cword>")<CR>\>/]], noisy)
nnoremap('<leader>]', [[:s/\<<C-r>=expand("<cword>")<CR>\>/]], noisy)
vnoremap('<leader>[', [["zy:%s/<C-r><C-o>"/]], noisy) -- all across the doc
-- Visual shifting (does not exit Visual mode)
vnoremap('<', '<gv')
vnoremap('>', '>gv')
--Remap back tick for jumping to marks more quickly back
nnoremap("'", '`')
-----------------------------------------------------------------------------//
--open a new file in the same directory
nnoremap('<leader>nf', [[:e <C-R>=expand("%:p:h") . "/" <CR>]], noisy)
--open a new file in the same directory
nnoremap('<leader>ns', [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], noisy)
--Open command line window - :<c-f>
nnoremap('<localleader>l', [[<cmd>nohlsearch<cr><cmd>diffupdate<cr><cmd>syntax sync fromstart<cr><c-l>]])
-----------------------------------------------------------------------------//
-- Window bindings
-----------------------------------------------------------------------------//
-- https://vim.fandom.com/wiki/Fast_window_resizing_with_plus/minus_keys
if fn.bufwinnr(1) then
  nnoremap('<S-h>', '<C-W><')
  nnoremap('<S-l>', '<C-W>>')
end
-----------------------------------------------------------------------------//
-- Open Common files
-----------------------------------------------------------------------------//
nnoremap('<leader>ez', ':e $HOME/.zshrc<cr>')
-- nnoremap('<leader>et', ':e ~/.tmux.conf<cr>')
-----------------------------------------------------------------------------//
-- Arrows
-----------------------------------------------------------------------------//
-- nnoremap('<down>', '<nop>')
-- nnoremap('<up>', '<nop>')
-- nnoremap('<left>', '<nop>')
-- nnoremap('<right>', '<nop>')
-- inoremap('<up>', '<nop>')
-- inoremap('<down>', '<nop>')
-- inoremap('<left>', '<nop>')
-- inoremap('<right>', '<nop>')
-- Repeat last substitute with flags
-- nnoremap('&', '<cmd>&&<CR>')
-- xnoremap('&', '<cmd>&&<CR>')
----------------------------------------------------------------------------------
-- Commandline mappings
----------------------------------------------------------------------------------
-- https://github.com/tpope/vim-rsi/blob/master/plugin/rsi.vim
-- c-a / c-e everywhere - RSI.vim provides these
-- cnoremap('<C-n>', '<Down>')
-- cnoremap('<C-p>', '<Up>')
-- <C-A> allows you to insert all matches on the command line e.g. bd *.js <c-a>
-- will insert all matching files e.g. :bd a.js b.js c.js
-- cnoremap('<c-x><c-a>', '<c-a>')
-- cnoremap('<C-a>', '<Home>')
-- cnoremap('<C-e>', '<End>')
-- cnoremap('<C-b>', '<Left>')
-- cnoremap('<C-d>', '<Del>')
-- cnoremap('<C-k>', [[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>]])
-- move cursor one character backwards unless at the end of the command line
-- cnoremap('<C-f>', [[getcmdpos() > strlen(getcmdline())? &cedit: "\<Lt>Right>"]], { expr = true })
-- see :h cmdline-editing
-- cnoremap('<Esc>b', [[<S-Left>]])
-- cnoremap('<Esc>f', [[<S-Right>]])
-- Insert escaped '/' while inputting a search pattern
cnoremap('/', [[getcmdtype() == "/" ? "\/" : "/"]], { expr = true })

-----------------------------------------------------------------------------//
-----------------------------------------------------------------------------//

-- Write and quit all files, ZZ is NOT equivalent to this
nnoremap('qa', '<cmd>qa<CR>')
------------------------------------------------------------------------------
-- Quickfix
------------------------------------------------------------------------------
nnoremap(']q', '<cmd>cnext<CR>zz')
nnoremap('[q', '<cmd>cprev<CR>zz')
nnoremap(']l', '<cmd>lnext<cr>zz')
nnoremap('[l', '<cmd>lprev<cr>zz')
------------------------------------------------------------------------------
-- Tab navigation
------------------------------------------------------------------------------
-- nnoremap('<leader>tn', '<cmd>tabedit %<CR>')
-- nnoremap('<leader>tc', '<cmd>tabclose<CR>')
-- nnoremap('<leader>to', '<cmd>tabonly<cr>')
-- nnoremap('<leader>tm', '<cmd>tabmove<Space>')
nnoremap(']t', '<cmd>tabprev<CR>')
nnoremap('[t', '<cmd>tabnext<CR>')
-------------------------------------------------------------------------------
-- ?ie | entire object
-------------------------------------------------------------------------------
xnoremap('ie', [[gg0oG$]])
onoremap('ie', [[<cmd>execute "normal! m`"<Bar>keepjumps normal! ggVG<CR>]])
----------------------------------------------------------------------------//
-- Core navigation
----------------------------------------------------------------------------//
-- Store relative line number jumps in the jumplist.
nnoremap('j', [[(v:count > 1 ? 'm`' . v:count : '') . 'gj']], { expr = true, silent = true })
nnoremap('k', [[(v:count > 1 ? 'm`' . v:count : '') . 'gk']], { expr = true, silent = true })
-- Zero should go to the first non-blank character not to the first column (which could be blank)
-- but if already at the first character then jump to the beginning
--@see: https://github.com/yuki-yano/zero.nvim/blob/main/lua/zero.lua
nnoremap('0', "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'", { expr = true })
-- when going to the end of the line in visual mode ignore whitespace characters
vnoremap('$', 'g_')
-- jk is escape, THEN move to the right to preserve the cursor position, unless
-- at the first column.  <esc> will continue to work the default way.
-- NOTE: this is a recursive mapping so anything bound (by a plugin) to <esc> still works
imap('kj', [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })
-- Toggle top/center/bottom
nmap('zz', [[(winline() == (winheight (0) + 1)/ 2) ?  'zt' : (winline() == 1)? 'zb' : 'zz']], { expr = true })

-- This line opens the vimrc in a vertical split
nnoremap('<leader>ev', [[<Cmd>vsplit $MYVIMRC<cr>]])
-- This line opens my plugins file in a vertical split
nnoremap('<leader>ep', fmt('<Cmd>split %s/lua/as/plugins/init.lua<CR>', fn.stdpath('config')))

-- This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap('<leader>sv', [[<Cmd>source $MYVIMRC<cr> <bar> :lua vim.notify('Sourced init.vim')<cr>]])
nnoremap('<leader>yf', [[:let @*=expand("%:p")<CR>]], 'yank file path into the clipboard')
-----------------------------------------------------------------------------//
-- Quotes
-----------------------------------------------------------------------------//
nnoremap([[<leader>"]], [[ciw"<c-r>""<esc>]])
nnoremap('<leader>`', [[ciw`<c-r>"`<esc>]])
nnoremap("<leader>'", [[ciw'<c-r>"'<esc>]])
nnoremap('<leader>)', [[ciw(<c-r>")<esc>]])
nnoremap('<leader>}', [[ciw{<c-r>"}<esc>]])

-----------------------------------------------------------------------------//
-- Multiple Cursor Replacement
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-----------------------------------------------------------------------------//
nnoremap('cn', '*``cgn')
nnoremap('cN', '*``cgN')

-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit cq to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit Enter to repeat the macro over search matches.
function as.mappings.setup_map()
  nnoremap('M', [[:nnoremap M n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z]])
end

vim.g.mc = as.replace_termcodes([[y/\V<C-r>=escape(@", '/')<CR><CR>]])
xnoremap('cn', [[g:mc . "``cgn"]], { expr = true, silent = true })
xnoremap('cN', [[g:mc . "``cgN"]], { expr = true, silent = true })
nnoremap('cq', [[:\<C-u>call v:lua.as.mappings.setup_map()<CR>*``qz]])
nnoremap('cQ', [[:\<C-u>call v:lua.as.mappings.setup_map()<CR>#``qz]])
xnoremap('cq', [[":\<C-u>call v:lua.as.mappings.setup_map()<CR>gv" . g:mc . "``qz"]], { expr = true })
xnoremap(
  'cQ',
  [[":\<C-u>call v:lua.as.mappings.setup_map()<CR>gv" . substitute(g:mc, '/', '?', 'g') . "``qz"]],
  { expr = true }
)
-----------------------------------------------------------------------------//
-- Command mode related
-----------------------------------------------------------------------------//
-- smooth searching, allow tabbing between search results similar to using <c-g>
-- or <c-t> the main difference being tab is easier to hit and remapping those keys
-- to these would swallow up a tab mapping
-- cnoremap('<Tab>', [[getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>/<C-r>/" : "<Tab>"]], { expr = true })
-- cnoremap('<S-Tab>', [[getcmdtype() == "/" || getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"]], { expr = true })
-- cnoremap('<C-j>', [[pumvisible() ? "\\<C-n>" : "\\<C-j>"]], { expr = true })
-- cnoremap('<C-k>', [[pumvisible() ? "\\<C-p>" : "\\<C-k>"]], { expr = true })
-- Smart mappings on the command line
cnoremap('w!!', [[w !sudo tee % >/dev/null]])
-- insert path of current file into a command
cnoremap('%%', "<C-r>=fnameescape(expand('%'))<cr>")
cnoremap('::', "<C-r>=fnameescape(expand('%:p:h'))<cr>/")
------------------------------------------------------------------------------
-- Credit: June Gunn <Leader>?/! | Google it / Feeling lucky
------------------------------------------------------------------------------
function as.mappings.google(pat, lucky)
  local query = '"' .. fn.substitute(pat, '["\n]', ' ', 'g') .. '"'
  query = fn.substitute(query, '[[:punct:] ]', [[\=printf("%%%02X", char2nr(submatch(0)))]], 'g')
  fn.system(fn.printf(vim.g.open_command .. ' "https://www.google.com/search?%sq=%s"', lucky and 'btnI&' or '', query))
end

nnoremap('<localleader>?', [[:lua as.mappings.google(vim.fn.expand("<cWORD>"), false)<cr>]])
nnoremap('<localleader>!', [[:lua as.mappings.google(vim.fn.expand("<cWORD>"), true)<cr>]])
xnoremap('<localleader>?', [["gy:lua as.mappings.google(vim.api.nvim_eval("@g"), false)<cr>gv]])
xnoremap('<localleader>!', [["gy:lua as.mappings.google(vim.api.nvim_eval("@g"), false, true)<cr>gv]])
----------------------------------------------------------------------------------
-- Grep Operator
----------------------------------------------------------------------------------
-- http://travisjeffery.com/b/2011/10/m-x-occur-for-vim/

---@param type string
---@return nil
function as.mappings.grep_operator(type)
  local saved_unnamed_register = fn.getreg('@@')
  if type:match('v') then
    vim.cmd([[normal! `<v`>y]])
  elseif type:match('char') then
    vim.cmd([[normal! `[v`]y']])
  else
    return
  end
  -- Store the current window so if it changes we can restore it
  local win = api.nvim_get_current_win()
  vim.cmd.grep({ fn.shellescape(fn.getreg('@@')) .. ' .', bang = true, mods = { silent = true } })
  fn.setreg('@@', saved_unnamed_register)
  if api.nvim_get_current_win() ~= win then
    vim.cmd.wincmd('p')
  end
end

-- nnoremap('<leader>g', [[:silent! set operatorfunc=v:lua.as.mappings.grep_operator<cr>g@]])
-- xnoremap('<leader>g', [[:call v:lua.as.mappings.grep_operator(visualmode())<cr>]])
nnoremap('<leader>g', function()
  vim.o.operatorfunc = 'v:lua.as.mappings.grep_operator'
  return 'g@'
end, { expr = true, desc = 'grep operator' })
xnoremap('<leader>g', ':call v:lua.as.mappings.grep_operator(visualmode())<CR>')
-----------------------------------------------------------------------------//

local function open(path)
  fn.jobstart({ vim.g.open_command, path }, { detach = true })
  vim.notify(fmt('Opening %s', path))
end
-----------------------------------------------------------------------------//
-- GX - replicate netrw functionality
-----------------------------------------------------------------------------//
local function open_link()
  local file = fn.expand('<cfile>')
  if fn.isdirectory(file) > 0 then
    return vim.cmd.edit(file)
  end

  if file:match('http[s]?://') then
    return open(file)
  end

  -- consider anything that looks like string/string a github link
  local plugin_url_regex = '[%a%d%-%.%_]*%/[%a%d%-%.%_]*'
  local link = string.match(file, plugin_url_regex)
  if link then
    return open(fmt('https://www.github.com/%s', link))
  end
end
nnoremap('gx', open_link)

nnoremap('gf', '<Cmd>e <cfile><CR>')

nnoremap('<leader>ls', as.toggle_qf_list)
nnoremap('<leader>li', as.toggle_loc_list)

-----------------------------------------------------------------------------//
-- Completion
-----------------------------------------------------------------------------//
-- cycle the completion menu with <TAB>
-- inoremap('<tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
-- inoremap('<s-tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
-----------------------------------------------------------------------------//
-- Commands
-----------------------------------------------------------------------------//
command('ToggleBackground', function()
  vim.o.background = vim.o.background == 'dark' and 'light' or 'dark'
end)
------------------------------------------------------------------------------
-- command('Todo', [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]])
command('ReloadModule', function(tbl)
  require('plenary.reload').reload_module(tbl.args)
end, {
  nargs = 1,
})
-- source https://superuser.com/a/540519
-- write the visual selection to the filename passed in as a command argument then delete the
-- selection placing into the black hole register
command('MoveWrite', [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]], {
  nargs = 1,
  bang = true,
  range = true,
  complete = 'file',
})
command('MoveAppend', [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]], {
  nargs = 1,
  bang = true,
  range = true,
  complete = 'file',
})

command('Reverse', '<line1>, <line2>g/^/m<line1>-1', { range = '%', bar = true })

-----------------------------------------------------------------------------//
-- Autoresize
-----------------------------------------------------------------------------//
-- Auto resize Vim splits to active split to 70% -
-- https://stackoverflow.com/questions/11634804/vim-auto-resize-focused-window

local auto_resize = function()
  local auto_resize_on = false
  return function(args)
    if not auto_resize_on then
      local factor = args and tonumber(args) or 70
      local fraction = factor / 10
      -- NOTE: mutating &winheight/&winwidth are key to how
      -- this functionality works, the API fn equivalents do
      -- not work the same way
      vim.cmd(fmt('let &winheight=&lines * %d / 10 ', fraction))
      vim.cmd(fmt('let &winwidth=&columns * %d / 10 ', fraction))
      auto_resize_on = true
      vim.notify('Auto resize ON')
    else
      vim.cmd([[
      let &winheight=30
      let &winwidth=30
      wincmd =
      ]])
      auto_resize_on = false
      vim.notify('Auto resize OFF')
    end
  end
end
command('AutoResize', auto_resize(), { nargs = '?' })
-----------------------------------------------------------------------------//

command('LuaInvalidate', function(pattern)
  require('as.utils').invalidate(pattern, true)
end, { nargs = 1 })
-----------------------------------------------------------------------------//
-- References
-----------------------------------------------------------------------------//
-- 1.) https://www.reddit.com/r/vim/comments/i2x8xc/i_want_gf_to_create_files_if_they_dont_exist/
-- 2.) https://github.com/kristijanhusak/neovim-config/blob/5474d932386c3724d2ce02a5963528fe5d5e1015/nvim/lua/partials/mappings.lua#L154
-- vim:fdm=marker
