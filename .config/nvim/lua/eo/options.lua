-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local fn, g, o, opt, uv, v = vim.fn, vim.g, vim.o, vim.opt, vim.uv, vim.v
-- local icons = eo.ui.icons
-- local misc = icons.misc

-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ','

-- cmd([[ set path=.,,,$PWD/**]])
-- cmd([[ set path=.,,**,$PWD/**,~/.config/nvim/**]])

-- Used for the "n" flag in 'formatoptions'
--                           ┌ recognize numbered lists (default)
--                           ├─────────────┐
opt.formatlistpat = [[^\s*\%(\d\+[\]:.)}\t ]\|[-*+]\)\s*]]
--                                            ├───┘
--                                            └ recognize unordered lists

g.query_lint_on = {}
vim.env.SHELL = '/opt/homebrew/bin/zsh'
opt.shell = '/opt/homebrew/bin/zsh'
-- opt.selection = 'inclusive' -- default => 'inclusive', 'exclusive' 'old' also a possible value.
opt.wrap = false
opt.wrapscan = true
opt.wrapmargin = 2
-- o.textwidth = 80
opt.colorcolumn = '+1'
-- o.wrapscan = true
-- opt.matchpairs:append('<:>')
-- opt.syntax = 'enable'
opt.incsearch = true
opt.smarttab = true
g.vimsyn_embed = 'alpPrj'
opt.path:append { '**' } --'**'
opt.synmaxcol = 300
opt.whichwrap = 'h,l'
opt.clipboard = { 'unnamedplus' }
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.infercase = true
opt.expandtab = true -- convert all tabs that are typed into spaces
opt.shiftwidth = 2
-- o.smartindent = true -- add <tab> depending on syntax (C/C++)
opt.autoindent = true
opt.shiftround = true

-- Use 'shiftwidth' for `TAB`/`BS` {{{
--
-- When we press `Tab` or `BS` in other locations (i.e. after first
-- non-whitespace), we don't want 'softtabstop' to determine how many spaces are
-- added/removed (nor 'tabstop', hence why we don't set 'softtabstop' to zero).
-- }}}
opt.softtabstop = -1

opt.swapfile = false
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.splitkeep = 'screen'
opt.splitbelow = true
opt.splitright = true
opt.eadirection = 'hor'
opt.termguicolors = true
opt.emoji = false
opt.guifont = {
  'CascadiaCodeNF',
  'CascadiaCodeNFItalic',
  'SymbolsNerdFont-Regular',
  'VictorMonoNerdFont-SemiBoldOblique:h10',
}
-- 'Symbols Nerd Font',
-- 'Delugia Italic:h12',
-- vim.opt.guicursor = 'n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor/lCursor,r-cr:hor20,o:hor50'
opt.guicursor = {
  'n-v-c-sm:block-Cursor',
  'i-ci-ve:ver25-iCursor',
  'r-cr-o:hor20-Cursor',
  'a:blinkon0',
}
-- function eo.modified_icon() return vim.bo.modified and icons.ui.Circle or '' end
-- function eo.modified_icon() return vim.bo.modified and misc.circle or '' end
-- o.titlestring = '%{fnamemodify(getcwd(), ":t")}%( %{v:lua.eo.modified_icon()}%)'
---@diagnostic disable-next-line: missing-parameter
opt.titleold = fn.fnamemodify(uv.os_getenv('SHELL'), ':t') or ''
opt.title = true
opt.titlelen = 70
opt.cursorlineopt = { 'both' }
opt.updatetime = 300
opt.timeout = true
opt.timeoutlen = 300
opt.ttimeoutlen = 50
opt.switchbuf = 'useopen,uselast'

opt.showmode = false
-- dont remember:
-- * help files since that will error if theyre from a lazy loaded plugin
-- * folds since they are created dynamically and might be missing on startup
opt.sessionoptions = {
  'globals',
  'buffers',
  'curdir',
  'winpos',
  'winsize',
  'help',
  'tabpages',
  'terminal',
  'localoptions',
  'blank',
}

opt.viewoptions = { 'cursor', 'folds' }
o.virtualedit = 'block,onemore' -- allow cursor to move where there is no text in visual block mode
opt.jumpoptions = { 'stack' } -- make jumplist behave like a browser stack
opt.list = true -- invisible chars
opt.listchars = {
  eol = nil,
  tab = '  ', -- Alternatives: '▷ ▷',
  extends = '…', -- Alternatives: … » ›
  precedes = '░', -- Alternatives: … « ‹
  trail = '•', -- BULLET (U+2022, UTF-8: E2 80 A2)
}

-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
opt.diffopt = vim.opt.diffopt
  + {
    'vertical',
    'iwhite',
    'hiddenoff',
    'foldcolumn:0',
    'context:4',
    'algorithm:histogram',
    'indent-heuristic',
    'linematch:60',
  }
-----------------------------------------------------------------------------//
-- Format Options {{{1
-----------------------------------------------------------------------------//

opt.formatoptions = {
  ['1'] = true,
  ['2'] = true, -- Use indent from 2nd line of a paragraph
  q = true, --  continue comments with gq"
  c = true, --  Auto-wrap comments using textwidth
  -- r = false, -- Continue comments when pressing Enter
  -- o = false, -- Continue comments using o or O with the correct comment leader
  -- t = false, -- autowrap lines using text width value
  n = true, --  Recognize numbered lists
  j = true, --  remove a comment leader when joining lines.
  -- Only break if the line was not longer than 'textwidth' when the insert
  -- started and only at a white character that has been entered during the
  -- current insert command.
  l = true,
  v = true,
}

vim.cmd([[ set formatoptions-=rot ]])
-- opt.formatoptions:remove { 'r', 'o', 't' }

-- NOTE: from akinsho dotfiles ... date: 10-14-2023
-- unfortunately folding in (n)vim is a mess, if you set the fold level to start
-- at X then it will auto fold anything at that level, all good so far. If you then
-- try to edit the content of your fold and the foldmethod=manual then it will
-- recompute the fold which when using nvim-ufo means it will be closed again...

-- o.foldlevelstart = 3
-- o.foldlevelstart = 9
-- o.foldlevel = 99
-- opt.foldmethod = 'expr'
-- opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- function eo.ui.foldtext()
--   local fold = vim.treesitter.foldtext() --[=[@as string[][]]=]
--   local c = v.foldend - v.foldstart + 1
--   fold[#fold + 1] = { (' ⋯ [%d Lines]'):format(c), 'Oprerator' }
--   return fold
-- end

-- opt.foldtext = 'v:lua.eo.ui.foldtext()'
opt.foldtext = ''

-- NOTE: from tbung/dotfiles/blob/main/config/nvim/lua/tillb/options.lua after seeing it akinsho's dotfile commit history &&
-- the corresponding reddit post @https://www.reddit.com/r/neovim/comments/16sqyjz/finally_we_can_have_highlighted_folds/
opt.fillchars = {
  eob = ' ', -- suppress '~' at EndOfBuffer
  diff = '╱', -- alternatives = ⣿ ░ ─
  msgsep = '─', -- alternatives: ‾ ─ ' '
  fold = ' ',
  foldopen = '▽', -- '▼' ''
  foldclose = '▷', -- '▶' ''
  foldsep = ' ',
}

opt.mouse = 'a'
o.mousefocus = false
o.mousemoveevent = true
opt.mousescroll = { 'ver:1', 'hor:6' }
opt.autowrite = false

-- o.conceallevel = 2
o.concealcursor = 'niv'
o.breakindentopt = 'sbr'
o.linebreak = true -- lines wrap at words rather than random chars
o.signcolumn = 'yes:2'
o.ruler = false
-- o.cmdheight = 2
-- oncomouse/dotfiles/blob/master/conf/vim/init.lua
o.cmdheight = 1
if fn.has('nvim-0.9') == 1 and opt.cmdheight == 0 then opt.showcmdloc = 'statusline' end
-- showcmdloc default: 'lawt', statusline, tabline (requires 'showtabline' enabled)
o.showbreak = [[↪ ]] -- Options include -> '…', '↳ ', '→','↪ '
o.confirm = false
o.laststatus = 3
o.showtabline = 1
opt.rnu = true
opt.nu = true
o.pumblend = 10 -- make popup window translucent
o.pumheight = 25
o.previewheight = 25
o.hlsearch = true
o.autowriteall = true -- automatically :write before running commands and changing files
opt.shortmess = {
  t = true, -- truncate file messages at start
  A = true, -- ignore annoying swap file messages
  o = true, -- file-read message overwrites previous
  O = true, -- file-read message overwrites previous
  T = true, -- truncate non-file messages in middle
  F = true, -- don't give file info when editing a file, NOTE: this breaks autocommand messages
  W = true, -- don't give "written" or "[w]" when writing
  s = true, -- don't give "[silent]" or "silent" when executing
  c = true, -- don't give |ins-completion-menu| messages
  -- q = true, -- always use internal messages for quickfix
  I = true, -- don't give intro message when starting vim
  a = true, -- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
}
o.wildcharm = ('\t'):byte()
-- o.wildmode = 'longest:full,full:full'
o.wildmode = 'longest,full:full'
-- o.wildmode = 'longest:list,full'
-- vim.o.wildmode = 'longest,list,full' -- stevearc dotfiles
-- o.wildmode = 'longest,full'
o.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
opt.wildignore = {
  '*.git/**',
  '**/.git/**',
  '*DS_Store*',
  '**/node_modules/**',
  'log/**',
  '*.aux',
  '*.out',
  '*.toc',
  '*.o',
  '*.obj',
  '*.dll',
  '*.jar',
  '*.pyc',
  '*.rbc',
  '*.class',
  '*.gif',
  '*.ico',
  '*.jpg',
  '*.jpeg',
  '*.png',
  '*.avi',
  '*.wav',
  -- Temp/System
  '*.*~',
  '*~ ',
  '*.swp',
  '*.lock',
  '.DS_Store',
  'tags.lock',
}
-- opt.wildoptions = { 'pum', 'fuzzy' }
opt.wildoptions = { 'pum' }
o.scrolloff = 3
o.sidescrolloff = 6
o.sidescroll = 1

if eo and not eo.falsy(fn.executable('rg')) then
  vim.o.grepprg = [[rg --glob "!{.git,.venv,node_modules}" --no-heading --vimgrep --smart-case --follow $*]]
  opt.grepformat = opt.grepformat ^ { '%f:%l:%c:%m' }
elseif eo and not eo.falsy(fn.executable('ag')) then
  vim.o.grepprg = [[ag --nogroup --nocolor --vimgrep]]
  opt.grepformat = opt.grepformat ^ { '%f:%l:%c:%m' }
end

vim.g.markdown_fenced_languages = {
  'go',
  'zsh=sh',
  'bash=sh',
  'lua',
  'python',
  'julia',
  'sql',
  'yaml',
}

-- Support for semantic highlighting https://github.com/neovim/neovim/pull/21100
g.lsp_semantic_enabled = 1

-- vim.cmd([[ syntax on plugin on indent on ]])
-- vim.treesitter.start()
-- hack: query caching not working normally for whatever reason
-- https://github.com/Saghen/tuque/blob/main/lua/config/options.lua#L114
-- local query_parse = vim.treesitter.query.parse
-- local cache = {}
-- vim.treesitter.query.parse = function(lang, query)
--   local hash = lang .. '-' .. vim.fn.sha256(query)
--   if cache[hash] then return cache[hash] end
--   local result = query_parse(lang, query)
--   cache[hash] = result
--   return result
-- end
